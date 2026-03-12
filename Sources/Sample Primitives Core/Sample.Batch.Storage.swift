/// Internal class-backed storage for batch elements.
///
/// Elements are stored in sorted order via a raw pointer. The class
/// provides reference-counted sharing for `Copyable` elements and
/// unique ownership for `~Copyable` elements.
@safe
@usableFromInline
final class _SampleBatchStorage<Element: ~Copyable>: @unchecked Sendable {

    @usableFromInline
    let base: UnsafeMutablePointer<Element>

    @usableFromInline
    let count: Int

    @usableFromInline
    init(base: UnsafeMutablePointer<Element>, count: Int) {
        unsafe self.base = base
        self.count = count
    }

    deinit {
        unsafe base.deinitialize(count: count)
        unsafe base.deallocate()
    }
}
