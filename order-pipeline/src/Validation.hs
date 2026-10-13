-- | An error-accumulating Applicative.
--
-- 'Validation' looks like 'Either', but its Applicative instance combines
-- the errors of BOTH sides instead of stopping at the first one.
-- It deliberately has NO Monad instance: a lawful 'Monad' must satisfy
-- @(<*>) = ap@, and 'ap' short-circuits, so it would disagree with the
-- accumulating '<*>' below.
module Validation
  ( Validation (..)
  , failure
  , toEither
  , fromEither
  ) where

import Data.List.NonEmpty (NonEmpty (..))

data Validation e a
  = Failure e
  | Success a
  deriving (Eq, Show)

-- Functor: change the success value, leave failures untouched.
instance Functor (Validation e) where
  fmap _ (Failure e) = Failure e
  fmap f (Success a) = Success (f a)

-- Applicative: independent checks run side by side; errors are combined.
instance Semigroup e => Applicative (Validation e) where
  pure = Success
  Failure a <*> Failure b = Failure (a <> b)
  Failure a <*> Success _ = Failure a
  Success _ <*> Failure b = Failure b
  Success f <*> Success x = Success (f x)

-- | A single failure, stored in a non-empty list so a Failure always
-- carries at least one error.
failure :: e -> Validation (NonEmpty e) a
failure e = Failure (e :| [])

toEither :: Validation e a -> Either e a
toEither (Failure e) = Left e
toEither (Success a) = Right a

fromEither :: Either e a -> Validation e a
fromEither (Left e)  = Failure e
fromEither (Right a) = Success a
