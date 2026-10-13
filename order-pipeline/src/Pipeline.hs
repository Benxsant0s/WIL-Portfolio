-- | Stages 2-4: transform, price/check stock, take payment.
-- These stages DEPEND on each other (no point charging a card if stock is
-- short), so they are sequenced with the Either Monad (do-notation).
module Pipeline
  ( processOrder
  , processOrderFailFast
  , mergeLines
  , priceOrder
  , priceLine
  , summarise
  , discountThreshold
  , sampleCatalogue
  , mockGateway
  ) where

import Control.Monad (when)
import Data.Bifunctor (first)
import Data.List (partition)
import Data.List.NonEmpty (NonEmpty (..))

import Types
import Validate
import Validation

-- | Transform: combine duplicate SKUs so stock is checked against the
-- TOTAL requested (otherwise two lines of 2 could both pass a stock of 2).
mergeLines :: [OrderLine] -> [OrderLine]
mergeLines = foldr insert []
  where
    insert l@(OrderLine s (Quantity q)) acc =
      case partition ((== s) . lineSku) acc of
        ([], rest) -> l : rest
        (OrderLine _ (Quantity q') : _, rest) ->
          OrderLine s (Quantity (q + q')) : rest

-- | Monad: each step can fail and later steps need earlier results.
priceLine :: Catalogue -> OrderLine -> Either ProcessError PricedLine
priceLine cat (OrderLine s (Quantity q)) = do
  p <- maybe (Left (UnknownProduct s)) Right (lookup s cat)
  when (productStock p < q) $ Left (OutOfStock s q (productStock p))
  pure (PricedLine s q (productPrice p * q))

-- | 5% discount on orders of R500.00 or more.
discountThreshold :: Cents
discountThreshold = 50000

summarise :: [PricedLine] -> Priced
summarise pls = Priced pls sub disc (sub - disc)
  where
    sub  = sum (map pricedAmount pls)
    disc = if sub >= discountThreshold then sub `div` 20 else 0

-- | Functor over the Either result: 'fmap summarise' only touches success.
priceOrder :: Catalogue -> [OrderLine] -> Either ProcessError Priced
priceOrder cat ls = fmap summarise (traverse (priceLine cat) ls)

-- | The full pipeline (chosen design):
--   validate (Applicative, accumulate) -> transform -> price (Monad)
--   -> pay (Monad). Payment only runs if everything before it succeeded.
processOrder :: Catalogue -> Gateway -> RawOrder -> Either OrderError Confirmation
processOrder cat gateway raw = do
  valid   <- first Invalid (toEither (validateOrder raw))
  priced  <- first Failed (priceOrder cat (mergeLines (orderLines valid)))
  receipt <- first Failed (gateway (orderCard valid) (pricedTotal priced))
  pure (Confirmation (orderEmail valid) (pricedLines priced) (pricedTotal priced) receipt)

-- | Comparison design: everything is fail-fast Either.
processOrderFailFast :: Catalogue -> Gateway -> RawOrder -> Either OrderError Confirmation
processOrderFailFast cat gateway raw = do
  valid   <- first (\e -> Invalid (e :| [])) (validateOrderFailFast raw)
  priced  <- first Failed (priceOrder cat (mergeLines (orderLines valid)))
  receipt <- first Failed (gateway (orderCard valid) (pricedTotal priced))
  pure (Confirmation (orderEmail valid) (pricedLines priced) (pricedTotal priced) receipt)

-- | Fake data for the demo and tests (no real customers or secrets).
sampleCatalogue :: Catalogue
sampleCatalogue =
  [ (Sku "BOLT-10",  Product 250    100)
  , (Sku "NUT-10",   Product 150    50)
  , (Sku "DRILL-1",  Product 129900 2)
  ]

-- | A pretend payment service driven by the token text.
mockGateway :: Gateway
mockGateway (CardToken t) amount
  | t == "tok_declined" = Left (PaymentDeclined "card declined")
  | t == "tok_outage"   = Left PaymentServiceUnavailable
  | otherwise           = Right (Receipt ("rcpt-" ++ t ++ "-" ++ show amount))
