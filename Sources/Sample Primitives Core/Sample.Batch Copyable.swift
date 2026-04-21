extension Sample.Batch where Element: Copyable {

    /// Creates a batch from an array of values, sorted by the given comparator.
    @inlinable
    public init(_ values: [Element], sortedBy comparator: Order.Comparator<Element>) {
        let sorted = values.sorted { comparator($0, $1).isLess }
        let count = sorted.count
        let pointer = UnsafeMutablePointer<Element>.allocate(capacity: Swift.max(count, 1))
        for i in 0..<count {
            unsafe (pointer + i).initialize(to: sorted[i])
        }
        self._storage = unsafe _SampleBatchStorage(base: pointer, count: count)
    }
}

extension Sample.Batch where Element: Comparison.`Protocol` & Copyable {

    /// Creates a batch from an array of values, sorted ascending.
    @inlinable
    public init(_ values: [Element]) {
        self.init(values, sortedBy: .ascending)
    }
}

extension Sample.Batch where Element: Swift.Comparable & Copyable {

    /// Creates a batch from an array of stdlib-Comparable values, sorted ascending.
    @_disfavoredOverload
    @inlinable
    public init(_ values: [Element]) {
        self.init(values, sortedBy: .ascending)
    }
}

// MARK: - Value-returning accessors

extension Sample.Batch where Element: Copyable {

    /// Returns the element at the given percentile position.
    ///
    /// Uses nearest-rank algorithm: `index = Int(count * p)` clamped to `count - 1`.
    @inlinable
    public func percentile(_ p: Double) -> Element? {
        guard count > 0 else { return nil }
        let index = Int(Double(count) * p)
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
