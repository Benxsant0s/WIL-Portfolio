-- | Stage 1: validation. The checks are INDEPENDENT of each other, so they
-- are combined with Functor/Applicative ('<$>' and '<*>') and every problem
-- is reported at once.
module Validate
  ( Errors
  , validateOrder
  , validateOrderFailFast
  , validateName
  , validateEmail
  , validateLine
  , validateLines
  , validateCard
  , trim
  ) where

import Data.Char (isAlphaNum, isDigit, isSpace)
import Data.List (dropWhileEnd, isPrefixOf)
import Data.List.NonEmpty (NonEmpty (..))

import Types
import Validation

type Errors = NonEmpty FieldError

maxQuantity :: Integer
maxQuantity = 100

trim :: String -> String
trim = dropWhileEnd isSpace . dropWhile isSpace

validateName :: String -> Validation Errors String
validateName raw
  | null t    = failure EmptyName
  | otherwise = Success t
  where t = trim raw

validateEmail :: String -> Validation Errors Email
validateEmail raw
  | ' ' `elem` t = bad
  | otherwise = case break (== '@') t of
      (local, '@' : domain)
        | not (null local)
        , '@' `notElem` domain
        , '.' `elem` domain
        , head domain /= '.'
        , last domain /= '.' -> Success (Email t)
      _ -> bad
  where
    t   = trim raw
    bad = failure (InvalidEmail t)

validateSku :: String -> Validation Errors Sku
validateSku raw
  | len >= 3 && len <= 12 && all okChar t = Success (Sku t)
  | otherwise                             = failure (InvalidSku t)
  where
    t        = trim raw
    len      = length t
    okChar c = (c >= 'A' && c <= 'Z') || isDigit c || c == '-'

parseInteger :: String -> Maybe Integer
parseInteger s = case reads (trim s) :: [(Integer, String)] of
  [(n, "")] -> Just n
  _         -> Nothing

validateQuantity :: String -> Validation Errors Quantity
validateQuantity raw = case parseInteger raw of
  Nothing -> failure (InvalidQuantity (trim raw))
  Just n
    | n < 1 || n > maxQuantity -> failure (QuantityOutOfRange n)
    | otherwise                -> Success (Quantity (fromInteger n))

-- | One line = two independent checks combined applicatively.
validateLine :: RawLine -> Validation Errors OrderLine
validateLine (RawLine s q) = OrderLine <$> validateSku s <*> validateQuantity q

-- | Many lines: 'traverse' runs validateLine on each and accumulates errors.
validateLines :: [RawLine] -> Validation Errors [OrderLine]
validateLines [] = failure EmptyOrder
validateLines ls = traverse validateLine ls

-- | Only tokens are accepted (e.g. "tok_abc123"), never real card numbers.
validateCard :: String -> Validation Errors CardToken
validateCard raw
  | "tok_" `isPrefixOf` t && length t > 4 && all ok t = Success (CardToken t)
  | otherwise                                          = failure InvalidCardToken
  where
    t    = trim raw
    ok c = isAlphaNum c || c == '_'

-- | The whole order: Functor + Applicative, errors accumulate.
validateOrder :: RawOrder -> Validation Errors ValidOrder
validateOrder (RawOrder n e ls c) =
  ValidOrder <$> validateName n
             <*> validateEmail e
             <*> validateLines ls
             <*> validateCard c

-- | Alternative design for the comparison: the same checks sequenced with
-- Either's Monad, so only the FIRST error is ever reported.
validateOrderFailFast :: RawOrder -> Either FieldError ValidOrder
validateOrderFailFast (RawOrder n e ls c) = do
  n'  <- firstError (validateName n)
  e'  <- firstError (validateEmail e)
  ls' <- firstError (validateLines ls)
  c'  <- firstError (validateCard c)
  pure (ValidOrder n' e' ls' c')

firstError :: Validation Errors a -> Either FieldError a
firstError (Success a)         = Right a
firstError (Failure (e :| _)) = Left e
