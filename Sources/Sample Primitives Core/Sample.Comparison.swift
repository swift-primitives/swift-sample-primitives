extension Sample {

    /// Regression comparison between two batches.
    ///
    /// Compares a `baseline` and `current` batch on a selected metric,
    /// computing the percentage change and classifying it as a regression
    /// or improvement based on polarity.
    ///
    /// ```swift
    /// let comparison = Sample.Comparison(
    ///     baseline: baselineSample,
    ///     current: currentSample,
    ///     metric: .p99,
    ///     polarity: .lowerIsBetter
    /// )
    /// comparison.change(using: .duration)  // -0.05 = 5% faster
    /// ```
    public struct Comparison<Element: Comparable & Sendable>: Sendable {

        /// The baseline batch.
        public let baseline: Sample.Batch<Element>

        /// The current batch.
        public let current: Sample.Batch<Element>

        /// The metric to compare.
        public let metric: Sample.Metric

        /// Whether lower or higher values are better.
        public let polarity: Sample.Polarity

        @inlinable
        public init(
            baseline: Sample.Batch<Element>,
            current: Sample.Batch<Element>,
            metric: Sample.Metric,
            polarity: Sample.Polarity
        ) {
            self.baseline = baseline
            self.current = current
            self.metric = metric
            self.polarity = polarity
        }

        /// Computes the relative change between baseline and current.
        ///
        /// Returns `(current - baseline) / baseline` as a fraction.
        /// Negative values indicate the current is smaller than the baseline.
        ///
        /// Returns `nil` if either batch is empty or the baseline value is zero.
        @inlinable
        public func change(
            using averaging: Sample.Averaging<Element>
        ) -> Double? {
            guard let baseValue = metric.extract(from: baseline, using: averaging),
                  let curValue = metric.extract(from: current, using: averaging) else {
                return nil
            }
            let baseDouble = averaging.project(baseValue)
            guard baseDouble != 0 else { return nil }
            return (averaging.project(curValue) - baseDouble) / baseDouble
        }

        /// Whether the current batch is a regression (worse than baseline).
        @inlinable
        public func isRegression(
            using averaging: Sample.Averaging<Element>
        ) -> Bool {
            guard let delta = change(using: averaging) else { return false }
            switch polarity {
            case .lowerIsBetter: return delta > 0
            case .higherIsBetter: return delta < 0
            }
        }

        /// Whether the current batch is an improvement (better than baseline).
        @inlinable
        public func isImprovement(
            using averaging: Sample.Averaging<Element>
        ) -> Bool {
            guard let delta = change(using: averaging) else { return false }
            switch polarity {
            case .lowerIsBetter: return delta < 0
            case .higherIsBetter: return delta > 0
            }
        }

        /// Whether the change exceeds the given tolerance (absolute fraction).
        @inlinable
        public func exceedsTolerance(
            _ tolerance: Double,
            using averaging: Sample.Averaging<Element>
        ) -> Bool {
            guard let delta = change(using: averaging) else { return false }
            return Swift.abs(delta) > tolerance
        }
    }
}

// MARK: - Convenience for Duration

extension Sample.Comparison where Element == Duration {

    /// The relative change between baseline and current Duration values.
    @inlinable
    public var change: Double? {
        change(using: .duration)
    }

    /// Whether the current batch is a regression.
    @inlinable
    public var isRegression: Bool {
        isRegression(using: .duration)
    }

    /// Whether the current batch is an improvement.
    @inlinable
    public var isImprovement: Bool {
        isImprovement(using: .duration)
    }

    /// Whether the change exceeds the given tolerance.
    @inlinable
    public func exceedsTolerance(_ tolerance: Double) -> Bool {
        exceedsTolerance(tolerance, using: .duration)
    }
}

// MARK: - Convenience for Double

extension Sample.Comparison where Element == Double {

    /// The relative change between baseline and current Double values.
    @inlinable
    public var change: Double? {
        change(using: .real)
    }

    /// Whether the current batch is a regression.
    @inlinable
    public var isRegression: Bool {
        isRegression(using: .real)
    }

    /// Whether the current batch is an improvement.
    @inlinable
    public var isImprovement: Bool {
        isImprovement(using: .real)
    }

    /// Whether the change exceeds the given tolerance.
    @inlinable
    public func exceedsTolerance(_ tolerance: Double) -> Bool {
        exceedsTolerance(tolerance, using: .real)
    }
}
