public import Sample_Primitive

// MARK: - Value-returning accessors

extension Sample.Batch where Element: Copyable {

    /// Returns the element at the given percentile position.
    ///
    /// Uses nearest-rank algorithm: `index = Int(count * p)` clamped to the last
    /// valid index.
    @inlinable
    public func percentile(_ p: Double) -> Element? {
        guard count > 0 else { return nil }
        let index = Int(Double(count) * p)
        // reason: Last-index clamp `Swift.min(index, count − 1)` for percentile
        // nearest-rank algorithm; `count` is stdlib Int (storage size). Math
        // IS the length-minus-one expression.
        let clamped = Swift.min(index, count - 1)
        return unsafe self._storage.base[clamped]
    }

    /// The minimum element (first in sorted order).
    @inlinable
    public var min: Element? {
        guard count > 0 else { return nil }
        return unsafe self._storage.base[0]
    }

    /// The maximum element (last in sorted order).
    @inlinable
    public var max: Element? {
        guard count > 0 else { return nil }
        // reason: Pointer last-element access via `base[count − 1]`; canonical
        // UnsafePointer subscript / pointer-arithmetic pattern. `count` is
        // stdlib Int.
        return unsafe self._storage.base[count - 1]
    }

    /// The median element (50th percentile).
    @inlinable
    public var median: Element? { percentile(0.5) }

    /// 50th percentile.
    @inlinable
    public var p50: Element? { percentile(0.50) }

    /// 75th percentile.
    @inlinable
    public var p75: Element? { percentile(0.75) }

    /// 90th percentile.
    @inlinable
    public var p90: Element? { percentile(0.90) }

    /// 95th percentile.
    @inlinable
    public var p95: Element? { percentile(0.95) }

    /// 99th percentile.
    @inlinable
    public var p99: Element? { percentile(0.99) }

    /// 99.9th percentile.
    @inlinable
    public var p999: Element? { percentile(0.999) }
}
