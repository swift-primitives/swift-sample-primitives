public import Sample_Averaging_Primitives
public import Sample_Primitive

extension Sample.Batch where Element: Copyable & Sendable {

    /// Computes the Median Absolute Deviation: median(|xi - median(X)|).
    ///
    /// MAD is a robust measure of statistical dispersion, resistant to outliers
    /// (unlike standard deviation). A single extreme value does not distort MAD.
    ///
    /// - Parameter averaging: Averaging witness providing arithmetic and projection.
    /// - Returns: MAD in the element's unit, or `nil` if empty.
    @inlinable
    public func medianAbsoluteDeviation(
        using averaging: Sample.Averaging<Element>
    ) -> Element? {
        guard count > 0, let med = median else { return nil }
        let medianDouble = averaging.project(med)

        var deviations: [Double] = []
        deviations.reserveCapacity(count)
        for i in 0..<count {
            let diff = abs(averaging.project(unsafe self._storage.base[i]) - medianDouble)
            deviations.append(diff)
        }
        deviations.sort()

        let madDouble: Double
        if deviations.count % 2 == 1 {
            madDouble = deviations[deviations.count / 2]
        } else {
            madDouble =
                (deviations[deviations.count / 2 - 1]
                    + deviations[deviations.count / 2]) / 2.0
        }
        return averaging.embed(madDouble)
    }

    /// Counts elements beyond `k × MAD` from the median (modified Z-score outlier detection).
    ///
    /// The standard threshold `k = 3.0` corresponds to approximately 3σ for normal
    /// distributions but remains robust for non-normal data.
    ///
    /// - Parameters:
    ///   - averaging: Averaging witness providing arithmetic and projection.
    ///   - k: Number of MADs from median to classify as outlier (default: 3.0).
    /// - Returns: Count of outliers, or `nil` if empty. Returns 0 if MAD is zero.
    @inlinable
    public func outlierCount(
        using averaging: Sample.Averaging<Element>,
        threshold k: Double = 3.0
    ) -> Int? {
        guard let med = median,
            let mad = medianAbsoluteDeviation(using: averaging)
        else { return nil }
        let medianDouble = averaging.project(med)
        let madDouble = averaging.project(mad)
        guard madDouble > 0 else { return 0 }

        var outliers = 0
        for i in 0..<self.count {
            let deviation = abs(averaging.project(unsafe self._storage.base[i]) - medianDouble)
            if deviation > k * madDouble {
                outliers += 1
            }
        }
        return outliers
    }
}

// MARK: - Convenience

extension Sample.Batch where Element == Duration {

    /// The Median Absolute Deviation of durations.
    @inlinable
    public var medianAbsoluteDeviation: Duration? {
        medianAbsoluteDeviation(using: .duration)
    }

    /// Count of duration outliers beyond `k × MAD` from the median.
    @inlinable
    public func outlierCount(threshold k: Double = 3.0) -> Int? {
        outlierCount(using: .duration, threshold: k)
    }
}

extension Sample.Batch where Element == Double {

    /// The Median Absolute Deviation.
    @inlinable
    public var medianAbsoluteDeviation: Double? {
        medianAbsoluteDeviation(using: .real)
    }

    /// Count of outliers beyond `k × MAD` from the median.
    @inlinable
    public func outlierCount(threshold k: Double = 3.0) -> Int? {
        outlierCount(using: .real, threshold: k)
    }
}
