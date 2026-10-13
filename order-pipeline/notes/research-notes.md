# Research and development notes

> The "What I learned" and "Problems I hit" parts MUST be in your own words,
> from what actually happened when you built and ran this. The technical
> reference below is a starting point to read, check and rewrite.

## 1. Topics beyond the supplied chapter (to read up on and confirm)
1. **Validation applicative.** `Either` cannot accumulate errors in `<*>`
   because its `Applicative` is derived from its `Monad` and short-circuits.
   A separate type with a `Semigroup e` constraint can combine errors.
2. **Why `Validation` has no `Monad`.** Monad law-compatibility requires
   `(<*>) = ap`. `ap` would stop at the first error, contradicting the
   accumulating `<*>`.
3. **`traverse` / Traversable.** `traverse f xs` runs an effectful function
   over a list and collects the results using the Applicative of the result type.
   With `Validation` it accumulates; with `Either` it stops at first error.
4. **`NonEmpty`.** Guarantees a `Failure` always holds at least one error,
   making `head`-style partial functions unnecessary.
5. **`Data.Bifunctor.first`.** Maps over the error side of `Either` to
   convert between error types in the pipeline.
6. **Semigroup/Monoid.** `<>` on lists/NonEmpty is how errors are combined.
7. **Applicative and Functor laws** and how to check them with example data.
8. **`reads` with `Integer`.** Parsing with `Int` can silently overflow;
   parsing as `Integer` then range-checking avoids that.
9. **Other ways to structure effectful workflows** (read, not implemented):
   `ExceptT e IO` (monad transformers, for real payment IO), `Writer` (audit
   logs), free monads / effect systems, and the `validation` package.

## 2. Comparison of two structures
| | A. Applicative validation → monadic processing | B. All fail-fast Either |
|---|---|---|
| Errors for 5 bad fields | 5 messages at once | 1 message, then resubmit |
| Customer effort | one correction round | up to five rounds |
| Code | custom `Validation` type + conversion | one type, plain `do` |
| Payment safety | payment only after stages 1–3 | same |
| Best for | independent form fields | dependent steps |

**Decision:** A for stage 1, monadic Either for stages 3–4, because forms
benefit from seeing all problems and payment needs strict ordering. Evidence:
tests "Bad order reports ALL 5 errors…" vs "Fail-fast design reports only the
first error" and "Out-of-stock order never reaches payment".

**Customer-facing wording choices:** every stock/payment message says the
customer was *not charged*; a declined card (user can act) is distinguished
from a gateway outage (retryable, see `isRetryable`); internal gateway
reasons are not shown to the customer.

## 3. What I learned  *(write in your own words)*
- 

## 4. Problems I hit and how I fixed them  *(write in your own words)*
- 

## 5. Sources I used  *(list the books, docs, pages you really read)*
- Supplied chapter: 
- 
