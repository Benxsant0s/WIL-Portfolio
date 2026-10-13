-- | Customer-facing wording for every error. Keeping this in one module
-- makes it easy to review exactly what a customer will see.
module Messages
  ( customerMessages
  , fieldMessage
  , processMessage
  , isRetryable
  , showMoney
  ) where

import qualified Data.List.NonEmpty as NE

import Types

customerMessages :: OrderError -> [String]
customerMessages (Invalid errs) = map fieldMessage (NE.toList errs)
customerMessages (Failed err)   = [processMessage err]

fieldMessage :: FieldError -> String
fieldMessage EmptyName = "Please enter your name."
fieldMessage (InvalidEmail e) = "The email address \"" ++ e ++ "\" does not look right."
fieldMessage EmptyOrder = "Your order has no items."
fieldMessage (InvalidSku s) = "\"" ++ s ++ "\" is not a valid product code."
fieldMessage (InvalidQuantity q) = "\"" ++ q ++ "\" is not a valid quantity."
fieldMessage (QuantityOutOfRange n) =
  "Quantity " ++ show n ++ " is not allowed. Please choose between 1 and 100."
fieldMessage InvalidCardToken = "Your payment details are missing or invalid."

processMessage :: ProcessError -> String
processMessage (UnknownProduct s) =
  "We could not find product " ++ unSku s ++ "."
processMessage (OutOfStock s wanted have) =
  "Sorry, only " ++ show have ++ " of " ++ unSku s ++ " left (you asked for "
    ++ show wanted ++ "). You have not been charged."
processMessage (PaymentDeclined _) =
  "Your card was declined. You have not been charged. Please try another card."
processMessage PaymentServiceUnavailable =
  "We could not reach the payment service. You have not been charged; please try again shortly."

-- | Should the customer simply try again later with the same details?
isRetryable :: ProcessError -> Bool
isRetryable PaymentServiceUnavailable = True
isRetryable _                         = False

showMoney :: Cents -> String
showMoney c = "R" ++ show (c `div` 100) ++ "." ++ pad (c `mod` 100)
  where pad n = (if n < 10 then "0" else "") ++ show n
