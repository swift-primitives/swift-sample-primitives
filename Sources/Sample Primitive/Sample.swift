/// Namespace for sample statistics types.
///
/// - ``Batch``: Batch statistics over a sorted collection of elements.
/// - ``Averaging``: Value witness for mean/sum computation.
/// - ``Accumulator``: Streaming O(1) monoid for UInt64 values.
/// - ``Metric``: Selector for named statistical metrics.
/// - ``Comparison``: Regression comparison between two batches.
/// - ``Polarity``: Direction indicator (lower-is-better vs higher-is-better).
/// - ``Regression``: Ordinary least-squares linear regression.
/// - ``Trend``: Statistical evidence about monotonic trend in an ordered sample.
public enum Sample {}
