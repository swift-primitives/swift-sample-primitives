public import Sample_Averaging_Primitives
public import Sample_Primitive

extension Sample.Batch where Element: Copyable & Sendable {

    /// Computes the coefficient of variation (CV = stddev / mean × 100) as a percentage.
    ///
    /// CV measures relative variability. Low CV (< 5%) indicates stable, trustworthy
    /// measurements. High CV (> 10%) indicates noisy, unreliable measurements.
    ///
    /// - Parameter averaging: Averaging witness providing arithmetic and projection.
    /// - Returns: CV as a percentage, or `nil` if fewer than 2 elements or mean is zero.
    @inlinable
    public func coefficientOfVariation(
        using averaging: Sample.Averaging<Element>
    ) -> Double? {
        guard let sd = standardDeviation(using: averaging),
            let m = mean(using: averaging)
        else { return nil }
        let meanDouble = averaging.project(m)
        guard meanDouble != 0 else { return nil }
        return (averaging.project(sd) / meanDouble) * 100.0
    }
}

// MARK: - Convenience

extension Sample.Batch where Element == Duration {

    /// The coefficient of variation of durations, as a percentage.
    @inlinable
    public var coefficientOfVariation: Double? {
        coefficientOfVariation(using: .duration)
    }
}

extension Sample.Batch where Element == Double {

    /// The coefficient of variation, as a percentage.
    @inlinable
    public var coefficientOfVariation: Double? {
        coefficientOfVariation(using: .real)
    }
}
