extension Sample.Batch where Element: Copyable & Sendable {

    /// Computes the sum of all elements using the given averaging witness.
    @inlinable
    public func sum(using averaging: Sample.Averaging<Element>) -> Element? {
        guard count > 0 else { return nil }
        var result = averaging.zero
        for i in 0..<count {
            result = averaging.adding(result, unsafe self._storage.base[i])
        }
        return result
    }

    /// Computes the arithmetic mean using the given averaging witness.
    @inlinable
    public func mean(using averaging: Sample.Averaging<Element>) -> Element? {
        guard let total = sum(using: averaging) else { return nil }
        return averaging.dividing(total, count)
    }
}

// MARK: - Convenience for known types

extension Sample.Batch where Element == Duration {

    /// The arithmetic mean of durations.
    @inlinable
    public var mean: Duration? { mean(using: .duration) }

    /// The sum of all durations.
    @inlinable
    public var sum: Duration? { sum(using: .duration) }
}

extension Sample.Batch where Element == Double {

    /// The arithmetic mean.
    @inlinable
    public var mean: Double? { mean(using: .real) }

    /// The sum of all values.
    @inlinable
    public var sum: Double? { sum(using: .real) }
}

extension Sample.Batch where Element == Int {

    /// The arithmetic mean (integer division).
    @inlinable
    public var mean: Int? { mean(using: .integer) }

    /// The sum of all values.
    @inlinable
    public var sum: Int? { sum(using: .integer) }
}
