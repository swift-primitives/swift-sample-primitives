extension Sample {

    /// Batch statistics over a sorted collection of elements.
    ///
    /// Elements are sorted at construction time and stored in sorted order,
    /// enabling O(1) access to percentiles, min, and max.
    ///
    /// Supports `~Copyable` elements via class-backed storage. When `Element`
    /// is `Copyable`, `Batch` is also `Copyable` (shared via reference counting).
    ///
    /// ```swift
    /// let sample = Sample.Batch([3.2, 1.5, 4.7, 2.1])
    /// sample.median       // 3.2
    /// sample.p99          // 4.7
    /// sample.mean(using: .real)  // 2.875
    /// ```
    public struct Batch<Element: ~Copyable>: ~Copyable {

        @usableFromInline
        let _storage: _SampleBatchStorage<Element>

        @inlinable
        public var count: Int { _storage.count }

        @inlinable
        public var isEmpty: Bool { count == 0 }
    }
}

extension Sample.Batch: Copyable where Element: Copyable {}
extension Sample.Batch: @unsafe @unchecked Sendable where Element: Sendable {}
