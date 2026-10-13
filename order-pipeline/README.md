# Customer Order Processing Pipeline (Haskell)

**Author:** <your name and student number>  **Module:** <module code>

## 1. The problem
An online shop receives orders typed in by customers. Each order must be
**validated**, **transformed**, **priced** (with a stock check) and **paid for**.
Any step can fail, and a customer should always be told *what* went wrong and
*whether they were charged*. The goal is a pipeline where every failure is an
explicit value in the type (`Either` / `Validation`), not an exception or a
`Maybe` that hides the reason.

## 2. Design
```
RawOrder (Strings)
  │  Stage 1  validate        Functor + Applicative  → ALL errors reported together
  ▼
ValidOrder
  │  Stage 2  transform       pure (merge duplicate SKUs)
  │  Stage 3  price + stock   Monad (Either)          → stops at first problem
  │  Stage 4  payment         Monad (Either)          → only runs if 1–3 succeeded
  ▼
Confirmation
```
| Pattern | Where | Why |
|---|---|---|
| Functor (`fmap`, `<$>`) | `summarise` over the pricing result; building `OrderLine`/`ValidOrder` | change the success value without touching the failure |
| Applicative (`<*>`, `traverse`) | `Validate.hs`, custom `Validation` type | field checks are independent, so run them all and accumulate errors |
| Monad (`do` on `Either`) | `Pipeline.hs` | later steps depend on earlier results; stop at first failure |

Files: `src/Validation.hs` (accumulating applicative), `src/Types.hs`,
`src/Validate.hs`, `src/Pipeline.hs`, `src/Messages.hs` (customer wording),
`app/Main.hs` (demo), `tests/Spec.hs` (tests).

### Research stretch: two ways of structuring the workflow
* **A. Applicative validation + monadic processing (chosen).**
* **B. Everything fail-fast `Either` (monadic) — `processOrderFailFast`.**

Customer-facing behaviour for an order with 5 mistakes:
* A shows all 5 messages at once, so the customer fixes them in one go.
* B shows one message, the customer fixes it, resubmits, sees the next… (up to 5 round trips).

For the later stages B-style sequencing is *correct*: the card must not be
charged if stock is short, so those steps are monadic in both designs.
Tests prove this ("Out-of-stock order never reaches payment"). Full
discussion in `notes/research-notes.md`.

## 3. How to run
Requires GHC (≥ 8.10) and, optionally, cabal. Only `base` is used, so no
downloads are needed.
```
cabal run order-demo
# or without cabal:
runghc -isrc app/Main.hs
```

## 4. How to run the tests
```
cabal test
# or without cabal:
runghc -isrc tests/Spec.hs
```
Output is one `PASS`/`FAIL` line per test and a final `N/N tests passed`;
the exit code is non-zero if any test fails. Tests cover the Functor and
Applicative laws on `Validation`, each validation rule, error accumulation
vs fail-fast, stock/discount/duplicate-line logic, stage ordering (payment
never reached after earlier failures) and customer message content.

## 5. Advantages
* Every failure is a visible constructor; the compiler warns about unhandled cases.
* Customers see all input mistakes at once.
* Raw vs validated types stop unvalidated data entering later stages.
* Pure functions (payment passed in as a `Gateway` function) make tests fast and deterministic.
* Only `base` is needed.

## 6. Disadvantages
* `Validation` is hand-written and has no `Monad` (by design), so you must remember which type to use where.
* Converting between `Validation` and `Either` adds a little boilerplate.
* Error lists need `NonEmpty` and `first` from `Data.Bifunctor`, which beginners find unfamiliar.

## 7. Known limitations
* Catalogue and stock are an in-memory list; no database, no concurrency, so two simultaneous customers could oversell (needs STM/DB transactions).
* The payment gateway is a pure mock; a real one needs `IO` (see notes on `ExceptT`).
* Email check is a simple shape check, not full RFC validation.
* Money is whole cents in `Int`; one currency only; discount rule is a fixed 5%.
* Stage 3 reports only the first stock/product problem, not all of them.
* Tests are example-based (no QuickCheck/property testing).
* I could not compile/run this in the environment where it was drafted; run the tests yourself and record the output (see `docs/`).

## 8. Security / privacy
No passwords, keys, API secrets, wallet words or real customer data are
included. All sample data is fictional, and the system accepts payment
*tokens* (`tok_...`) rather than card numbers.
