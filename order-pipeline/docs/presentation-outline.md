# Presentation outline (about 5–8 minutes)

> You must present this in your OWN voice. Use these as prompts; replace the
> bullets with your own sentences and add your own examples.

1. **The problem** – a customer submits an order; things can go wrong in many ways; how do we keep failures explicit?
2. **The pipeline** – show the diagram from the README: validate → transform → price → pay.
3. **Functor** – show `fmap summarise` or `<$>` in `validateOrder`. What does it leave alone?
4. **Applicative** – show `validateOrder`. Run the demo "Many mistakes at once" so the audience sees 5 messages.
5. **Monad** – show `processOrder`'s `do` block. Explain why payment can't run before stock is checked.
6. **Research comparison** – show A vs B and the customer experience of each (use `processOrderFailFast` on the bad order).
7. **Evidence of testing** – paste your real `runghc -isrc tests/Spec.hs` output (N/N passed) in a screenshot. Mention law tests, the stage-ordering tests, and the overflow test.
8. **Advantages / disadvantages** – from the README, in your words.
9. **Limitations & next steps** – concurrency, real `IO` gateway with `ExceptT`, property tests.

Checklist before presenting: run the tests yourself; save the output; practise the demo.
