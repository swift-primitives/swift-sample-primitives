@_exported public import Comparison_Primitives
@_exported public import Order_Primitives
public import Sample_Primitive

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

extension Sample.Batch where Element: Comparison.`Protocol` & SendableMetatype & Copyable {

    /// Creates a batch from an array of values, sorted ascending.
    @inlinable
    public init(_ values: [Element]) {
        self.init(values, sortedBy: .ascending)
    }
}
