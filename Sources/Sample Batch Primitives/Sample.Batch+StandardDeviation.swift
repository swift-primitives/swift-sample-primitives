public import Sample_Averaging_Primitives
public import Sample_Primitive

extension Sample.Batch where Element: Copyable & Sendable {

    /// Computes the sample standard deviation (Bessel's correction, `n-1` divisor).
    ///
    /// Uses the averaging witness to compute the mean, then projects elements
    /// to `Double` for variance computation via `averaging.project`/`averaging.embed`.
    ///
    /// - Parameter averaging: Averaging witness providing arithmetic and projection.
    /// - Returns: The standard deviation, or `nil` if fewer than 2 elements.
    @inlinable
    public func standardDeviation(
        using averaging: Sample.Averaging<Element>
    ) -> Element? {
        guard count > 1, let m = mean(using: averaging) else { return nil }
        let meanDouble = averaging.project(m)
        var sumSquares: Double = 0
        for i in 0..<count {
            let diff = averaging.project(unsafe self._storage.base[i]) - meanDouble
            sumSquares += diff * diff
        }
        // reason: Bessel's correction n−1 sample variance denominator;
        // canonical statistics formula. `seconds` underlies stdlib types,
        // no typed Cardinal surface available. Math reads as math: n−1
        // IS the degrees-of-freedom expression.
        // swiftlint:disable:next cardinal_count_minus_one_anti_pattern
        let variance = sumSquares / Double(count - 1)
        return averaging.embed(variance.squareRoot())
    }
}

// MARK: - Convenience

extension Sample.Batch where Element == Duration {

    /// The sample standard deviation of durations.
    @inlinable
    public var standardDeviation: Duration? {
        standardDeviation(using: .duration)
    }
}

extension Sample.Batch where Element == Double {

    /// The sample standard deviation.
    @inlinable
    public var standardDeviation: Double? {
        standardDeviation(using: .real)
    }
}
