# Sample Primitives Scope

The identity surface of `swift-sample-primitives`.

## Identity

`swift-sample-primitives` provides the substrate for **descriptive statistics
over a collected sample of measurements** — batch order-statistics (percentiles,
min/max/median), streaming accumulation, averaging witnesses, dispersion
measures (standard deviation, coefficient of variation, median absolute
deviation), regression comparison, and ordinary least-squares linear fit. It is
the `Sample.*` namespace.

## Core targets

- `Sample Primitive` — the `Sample` namespace plus its zero-dependency
  foundational types: `Sample.Accumulator` (streaming O(1) monoid),
  `Sample.Polarity` (lower/higher-is-better direction), and
  `Sample.Regression` / `Sample.Regression.Fit` / `Sample.Regression.linear`
  (ordinary least-squares).
- `Sample Averaging Primitives` — `Sample.Averaging`, the value witness for
  mean/projection (conforms to `Witness.Protocol`).
- `Sample Accumulator Primitives` — the `Sample.Accumulator` commutative-monoid
  witness (`Algebra.Monoid`).
- `Sample Batch Primitives` — the `Sample.Batch` sorted-collection statistics
  type in full (construction, percentile/min/max accessors, and the
  `Averaging`-driven dispersion methods) together with `Sample.Comparison` and
  `Sample.Metric`, which select and compare batch metrics.

## Out of scope

- Inferential statistics (hypothesis tests, confidence intervals, distribution
  fitting): lives in consumer code or a future dedicated package.
- Time-series / windowing primitives: → consumer code.
- The measurement clock and duration types themselves: → `swift-time-primitives`.
- General numeric reductions unrelated to a sample: → `swift-numeric-primitives`.

## Evaluation rule

Sub-target additions are evaluated against this scope. If a proposed addition is
OUT of scope, it extracts to a sibling package, not into this one.
