public import Sample_Averaging_Primitives
public import Sample_Primitive

extension Sample {

    /// Selector for named statistical metrics.
    ///
    /// Used with ``Comparison`` to specify which metric to compare between
    /// baseline and current batches.
    public enum Metric: Swift.String, Sendable, Hashable, Codable {
        case min
        case max
        case median
        case mean
        case p50
        case p75
        case p90
        case p95
        case p99
        case p999
    }
}

extension Sample.Metric {

    /// Extracts the selected metric from a batch using the given averaging witness.
    ///
    /// Returns `nil` if the batch is empty (or for `mean`/`standardDeviation` if
    /// the averaging operation cannot produce a result).
    @inlinable
    public func extract<T: Comparable & Sendable>(
        from batch: Sample.Batch<T>,
        using averaging: Sample.Averaging<T>
    ) -> T? {
        switch self {
        case .min: batch.min
        case .max: batch.max
        case .median: batch.median
        case .mean: batch.mean(using: averaging)
        case .p50: batch.p50
        case .p75: batch.p75
        case .p90: batch.p90
        case .p95: batch.p95
        case .p99: batch.p99
        case .p999: batch.p999
        }
    }
}
