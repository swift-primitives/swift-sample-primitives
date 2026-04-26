
extension Sample.Batch where Element: ~Copyable {

    /// Creates a batch from elements produced by a closure, sorted by the given comparator.
    ///
    /// Elements are initialized into a contiguous buffer and sorted in-place
    /// using move semantics, supporting `~Copyable` element types.
    ///
    /// - Parameters:
    ///   - count: The number of elements to produce.
    ///   - comparator: Order comparator for sorting elements.
    ///   - body: Closure called with each index `0..<count` to produce an element.
    @inlinable
    public init(
        count: Int,
        sortedBy comparator: Order.Comparator<Element>,
        initializingWith body: (Int) -> Element
    ) {
        let pointer = UnsafeMutablePointer<Element>.allocate(capacity: Swift.max(count, 1))
        for i in 0..<count {
            unsafe (pointer + i).initialize(to: body(i))
        }
        unsafe Self._insertionSort(pointer, count: count, comparator: comparator)
        self._storage = unsafe _SampleBatchStorage(base: pointer, count: count)
    }

    /// Borrows the element at the given percentile position.
    ///
    /// - Parameters:
    ///   - p: Percentile in `0.0...1.0`.
    ///   - body: Closure receiving a borrow of the element.
    /// - Returns: The result of `body`, or `nil` if the batch is empty.
    @inlinable
    public borrowing func withPercentile<R: ~Copyable>(
        _ p: Double,
        _ body: (borrowing Element) -> R
    ) -> R? {
        guard count > 0 else { return nil }
        let index = Int(Double(count) * p)
        let clamped = Swift.min(index, count - 1)
        return unsafe body((self._storage.base + clamped).pointee)
    }

    /// Borrows the minimum element (first in sorted order).
    @inlinable
    public borrowing func withMin<R: ~Copyable>(_ body: (borrowing Element) -> R) -> R? {
        guard count > 0 else { return nil }
        return unsafe body(self._storage.base.pointee)
    }

    /// Borrows the maximum element (last in sorted order).
    @inlinable
    public borrowing func withMax<R: ~Copyable>(_ body: (borrowing Element) -> R) -> R? {
        guard count > 0 else { return nil }
        return unsafe body((self._storage.base + count - 1).pointee)
    }

    /// Borrows the median element.
    @inlinable
    public borrowing func withMedian<R: ~Copyable>(_ body: (borrowing Element) -> R) -> R? {
        withPercentile(0.5, body)
    }
}

extension Sample.Batch where Element: ~Copyable {

    @usableFromInline
    static func _insertionSort(
        _ base: UnsafeMutablePointer<Element>,
        count: Int,
        comparator: Order.Comparator<Element>
    ) {
        guard count > 1 else { return }
        for i in 1..<count {
            var j = i
            while j > 0 {
                let shouldSwap = unsafe comparator(
                    (base + j - 1).pointee,
                    (base + j).pointee
                ).isGreater
                guard shouldSwap else { break }
                let temp = unsafe (base + j).move()
                unsafe (base + j).initialize(to: (base + j - 1).move())
                unsafe (base + j - 1).initialize(to: temp)
                j -= 1
            }
        }
    }
}
