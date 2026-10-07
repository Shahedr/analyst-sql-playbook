# Contributing

Contributions are welcome, especially new analyst-style SQL challenges.

A good challenge should include:

- a clear business question
- the expected output columns
- any assumption needed to interpret revenue, returns, dates, or customer behavior
- a matching solution that runs on PostgreSQL
- readable SQL rather than code-golf

## Adding a challenge

1. Add the prompt to the appropriate file under challenges/.
2. Add one solution under solutions/.
3. If the challenge needs new data, update the deterministic seed rather than adding private or proprietary data.
4. Make sure the existing SQL workflow still passes.

There can be multiple valid SQL solutions. The goal of the solution files is to show a clear approach, not to claim there is only one correct query.
