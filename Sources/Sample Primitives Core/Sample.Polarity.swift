extension Sample {

    /// Direction indicator for performance metrics.
    ///
    /// Determines whether a lower or higher value represents better performance.
    ///
    /// - `lowerIsBetter`: Used for latency, execution time, memory usage.
    /// - `higherIsBetter`: Used for throughput, operations per second.
    public enum Polarity: Sendable, Hashable {
        case lowerIsBetter
        case higherIsBetter
    }
}
