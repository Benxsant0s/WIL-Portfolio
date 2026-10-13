-- | Automated tests. No external test library: only base, so they run with
--   cabal test        or        runghc -isrc tests/Spec.hs
module Main (main) where

import Control.Monad (unless)
import Data.List (isInfixOf)
import qualified Data.List.NonEmpty as NE
import System.Exit (exitFailure)

import Messages
import Pipeline
import Types
import Validate
import Validation

type V = Validation [String]

-- Sample values for the law checks (successes and failures).
vals :: [V Int]
vals = [Success 1, Success 2, Failure ["a"], Failure ["b"]]

funs :: [V (Int -> Int)]
funs = [Success (+ 1), Success (* 2), Failure ["f"], Failure ["g"]]

f1, g1 :: Int -> Int
f1 = (+ 3)
g1 = (* 5)

-- Sample orders (fictional data only).
goodOrder :: RawOrder
goodOrder = RawOrder "Test Customer" "test@example.com"
  [RawLine "BOLT-10" "2", RawLine "NUT-10" "4"] "tok_ok123"

badOrder :: RawOrder
badOrder = RawOrder "  " "not-an-email" [RawLine "bad sku" "abc"] "1234"

orderWith :: [RawLine] -> String -> RawOrder
orderWith ls card = RawOrder "Test Customer" "test@example.com" ls card

run :: RawOrder -> Either OrderError Confirmation
run = processOrder sampleCatalogue mockGateway

declineAll, outageAll :: Gateway
declineAll _ _ = Left (PaymentDeclined "declined")
outageAll _ _  = Left PaymentServiceUnavailable

isInvalid :: Either OrderError a -> Bool
isInvalid (Left (Invalid _)) = True
isInvalid _                  = False

invalidErrors :: Either OrderError a -> [FieldError]
invalidErrors (Left (Invalid es)) = NE.toList es
invalidErrors _                   = []

tests :: [(String, Bool)]
tests =
  -- Functor laws (Validation)
  [ ("Functor identity", all (\v -> fmap id v == v) vals)
  , ("Functor composition", all (\v -> fmap (f1 . g1) v == (fmap f1 . fmap g1) v) vals)

  -- Applicative laws (Validation)
  , ("Applicative identity", all (\v -> (pure id <*> v) == v) vals)
  , ("Applicative homomorphism", (pure f1 <*> pure 7 :: V Int) == pure (f1 7))
  , ("Applicative interchange",
      and [ (u <*> pure 4) == (pure ($ 4) <*> u) | u <- funs ])
  , ("Applicative composition",
      and [ (pure (.) <*> u <*> v <*> w) == (u <*> (v <*> w))
          | u <- funs, v <- funs, w <- vals ])
  , ("Validation accumulates both errors",
      ((,) <$> (Failure ["x"] :: V Int) <*> (Failure ["y"] :: V Int)) == Failure ["x", "y"])

  -- Validation behaviour
  , ("Valid order passes validation", case validateOrder goodOrder of
        Success _ -> True
        _         -> False)
  , ("Bad order reports ALL 5 errors in field order",
      invalidErrors (run badOrder)
        == [ EmptyName, InvalidEmail "not-an-email", InvalidSku "bad sku"
           , InvalidQuantity "abc", InvalidCardToken ])
  , ("Fail-fast design reports only the first error",
      validateOrderFailFast badOrder == Left EmptyName)
  , ("Empty order rejected", invalidErrors (run (orderWith [] "tok_ok123")) == [EmptyOrder])
  , ("Quantity 0 rejected",
      invalidErrors (run (orderWith [RawLine "BOLT-10" "0"] "tok_ok123"))
        == [QuantityOutOfRange 0])
  , ("Quantity 101 rejected",
      invalidErrors (run (orderWith [RawLine "BOLT-10" "101"] "tok_ok123"))
        == [QuantityOutOfRange 101])
  , ("Huge quantity does not overflow",
      invalidErrors (run (orderWith [RawLine "BOLT-10" "99999999999999999999"] "tok_ok123"))
        == [QuantityOutOfRange 99999999999999999999])
  , ("Negative quantity rejected",
      invalidErrors (run (orderWith [RawLine "BOLT-10" "-3"] "tok_ok123"))
        == [QuantityOutOfRange (-3)])
  , ("Decimal quantity rejected",
      invalidErrors (run (orderWith [RawLine "BOLT-10" "2.5"] "tok_ok123"))
        == [InvalidQuantity "2.5"])
  , ("Raw card number rejected (tokens only)",
      invalidErrors (run (orderWith [RawLine "BOLT-10" "1"] "4111111111111111"))
        == [InvalidCardToken])
  , ("Whitespace around fields is trimmed",
      fmap confTotal (run (RawOrder "  Test  " " test@example.com "
                           [RawLine " BOLT-10 " " 2 "] "tok_ok123")) == Right 500)

  -- Monad stages
  , ("Good order total = 2*250 + 4*150 = 1100",
      fmap confTotal (run goodOrder) == Right 1100)
  , ("Good order gets a receipt",
      fmap confReceipt (run goodOrder) == Right (Receipt "rcpt-tok_ok123-1100"))
  , ("Discount applied at/above threshold (129900 - 6495)",
      fmap confTotal (run (orderWith [RawLine "DRILL-1" "1"] "tok_ok123")) == Right 123405)
  , ("No discount just below threshold",
      fmap confTotal (run (orderWith [RawLine "NUT-10" "50"] "tok_ok123")) == Right 7500)
  , ("Unknown product", run (orderWith [RawLine "GLUE-1" "1"] "tok_ok123")
        == Left (Failed (UnknownProduct (Sku "GLUE-1"))))
  , ("Out of stock reports requested and available",
      run (orderWith [RawLine "DRILL-1" "3"] "tok_ok123")
        == Left (Failed (OutOfStock (Sku "DRILL-1") 3 2)))
  , ("Duplicate lines are merged into one",
      fmap (map pricedQty . confLines) (run (orderWith
        [RawLine "BOLT-10" "3", RawLine "BOLT-10" "2"] "tok_ok123")) == Right [5])
  , ("Duplicate lines cannot oversell stock",
      run (orderWith [RawLine "DRILL-1" "2", RawLine "DRILL-1" "2"] "tok_ok123")
        == Left (Failed (OutOfStock (Sku "DRILL-1") 4 2)))

  -- Payment behaviour and ordering of stages
  , ("Card declined", run (orderWith [RawLine "BOLT-10" "1"] "tok_declined")
        == Left (Failed (PaymentDeclined "card declined")))
  , ("Payment outage", run (orderWith [RawLine "BOLT-10" "1"] "tok_outage")
        == Left (Failed PaymentServiceUnavailable))
  , ("Invalid order never reaches payment",
      isInvalid (processOrder sampleCatalogue declineAll badOrder))
  , ("Out-of-stock order never reaches payment",
      processOrder sampleCatalogue outageAll (orderWith [RawLine "DRILL-1" "3"] "tok_ok123")
        == Left (Failed (OutOfStock (Sku "DRILL-1") 3 2)))
  , ("Fail-fast pipeline agrees with applicative one on good input",
      processOrderFailFast sampleCatalogue mockGateway goodOrder == run goodOrder)
  , ("Fail-fast pipeline shows only 1 error for bad input",
      length (invalidErrors (processOrderFailFast sampleCatalogue mockGateway badOrder)) == 1)

  -- Customer-facing behaviour
  , ("Bad order gives 5 separate customer messages",
      either (length . customerMessages) (const 0) (run badOrder) == 5)
  , ("Declined message says customer was not charged",
      "not been charged" `isInfixOf` processMessage (PaymentDeclined "x"))
  , ("Out-of-stock message says customer was not charged",
      "not been charged" `isInfixOf` processMessage (OutOfStock (Sku "A") 3 2))
  , ("Messages never leak the gateway's internal reason",
      not ("secret-reason" `isInfixOf` processMessage (PaymentDeclined "secret-reason")))
  , ("Only outage is retryable",
      isRetryable PaymentServiceUnavailable && not (isRetryable (PaymentDeclined "x")))
  , ("Money formatting", map showMoney [0, 5, 250, 123405] == ["R0.00", "R0.05", "R2.50", "R1234.05"])
  ]

main :: IO ()
main = do
  mapM_ report tests
  let failed = [name | (name, ok) <- tests, not ok]
  putStrLn (show (length tests - length failed) ++ "/" ++ show (length tests) ++ " tests passed")
  unless (null failed) exitFailure
  where
    report (name, ok) = putStrLn ((if ok then "PASS  " else "FAIL  ") ++ name)
