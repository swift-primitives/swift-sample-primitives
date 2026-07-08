extension Sample {

    /// Streaming O(1) accumulator for `UInt64` values.
    ///
    /// Tracks count, sum, min, and max with wrapping arithmetic on the hot path.
    /// Forms a commutative monoid under ``merged(with:)`` — accumulators from
    /// independent measurement runs can be combined without loss.
    ///
    /// ```swift
    /// var acc = Sample.Accumulator.empty
    /// acc.record(42)
    /// acc.record(17)
    /// acc.count  // 2
    /// acc.mean   // 29
    /// ```
    @frozen
    public struct Accumulator: Sendable, Hashable {

        /// Number of recorded values.
        public var count: UInt64

        /// Sum of all recorded values (wrapping).
        public var sum: UInt64

        /// Minimum recorded value, or `UInt64.max` if empty.
        public var minimum: UInt64

        /// Maximum recorded value, or `0` if empty.
        public var maximum: UInt64

        /// Creates an accumulator with the given count, sum, minimum, and maximum.
        @inlinable
        public init(count: UInt64, sum: UInt64, minimum: UInt64, maximum: UInt64) {
            self.count = count
            self.sum = sum
            self.minimum = minimum
            self.maximum = maximum
        }
    }
}

extension Sample.Accumulator {

    /// The empty accumulator (identity element for the monoid).
    @inlinable
    public static var empty: Self {
        .init(count: 0, sum: 0, minimum: .max, maximum: 0)
    }

    /// Records a single value.
    @inlinable
    public mutating func record(_ value: UInt64) {
        count &+= 1
        sum &+= value
        minimum = Swift.min(minimum, value)
        maximum = Swift.max(maximum, value)
    }

    /// Merges two accumulators (the monoid operation).
    @inlinable
    public func merged(with other: Self) -> Self {
        .init(
            count: count &+ other.count,
            sum: sum &+ other.sum,
            minimum: Swift.min(minimum, other.minimum),
            maximum: Swift.max(maximum, other.maximum)
        )
    }

    /// The arithmetic mean (integer division), or `nil` if empty.
    @inlinable
    public var mean: UInt64? {
        guard count > 0 else { return nil }
        return sum / count
    }
}
