-- | Domain types. Raw (untrusted) input and validated data are separate
-- types, so the compiler stops unvalidated data entering the pipeline.
module Types where

import Data.List.NonEmpty (NonEmpty)

newtype Email     = Email String deriving (Eq, Show)
newtype Sku       = Sku { unSku :: String } deriving (Eq, Show)
newtype Quantity  = Quantity Int deriving (Eq, Ord, Show)
newtype CardToken = CardToken String deriving (Eq, Show)  -- a token, never a card number
newtype Receipt   = Receipt String deriving (Eq, Show)

-- | Money in cents (integer arithmetic avoids floating point errors).
type Cents = Int

-- Raw input: everything is a String, nothing is trusted.
data RawLine = RawLine
  { rawSku :: String
  , rawQty :: String
  } deriving (Eq, Show)

data RawOrder = RawOrder
  { rawName  :: String
  , rawEmail :: String
  , rawLines :: [RawLine]
  , rawCard  :: String
  } deriving (Eq, Show)

-- Validated data.
data OrderLine = OrderLine
  { lineSku :: Sku
  , lineQty :: Quantity
  } deriving (Eq, Show)

data ValidOrder = ValidOrder
  { orderName  :: String
  , orderEmail :: Email
  , orderLines :: [OrderLine]
  , orderCard  :: CardToken
  } deriving (Eq, Show)

-- Catalogue / stock (in-memory, for the project).
data Product = Product
  { productPrice :: Cents
  , productStock :: Int
  } deriving (Eq, Show)

type Catalogue = [(Sku, Product)]

-- Priced order.
data PricedLine = PricedLine
  { pricedSku    :: Sku
  , pricedQty    :: Int
  , pricedAmount :: Cents
  } deriving (Eq, Show)

data Priced = Priced
  { pricedLines :: [PricedLine]
  , subtotal    :: Cents
  , discount    :: Cents
  , pricedTotal :: Cents
  } deriving (Eq, Show)

-- Errors are data, not exceptions, so every failure case is explicit.
data FieldError
  = EmptyName
  | InvalidEmail String
  | EmptyOrder
  | InvalidSku String
  | InvalidQuantity String
  | QuantityOutOfRange Integer
  | InvalidCardToken
  deriving (Eq, Show)

data ProcessError
  = UnknownProduct Sku
  | OutOfStock Sku Int Int        -- sku, requested, available
  | PaymentDeclined String
  | PaymentServiceUnavailable
  deriving (Eq, Show)

data OrderError
  = Invalid (NonEmpty FieldError)
  | Failed ProcessError
  deriving (Eq, Show)

-- | The payment service is passed in as a function, so tests stay pure.
type Gateway = CardToken -> Cents -> Either ProcessError Receipt

data Confirmation = Confirmation
  { confEmail   :: Email
  , confLines   :: [PricedLine]
  , confTotal   :: Cents
  , confReceipt :: Receipt
  } deriving (Eq, Show)
