/// Internal class-backed storage for batch elements.
///
/// Elements are stored in sorted order via a raw pointer. The class
/// provides reference-counted sharing for `Copyable` elements and
/// unique ownership for `~Copyable` elements.
@safe
@usableFromInline
// WHY: Category D — structural Sendable workaround (SP-7).
// WHY: Unconditional @unchecked Sendable on a non-~Copyable class.
// WHY: Raw pointer + immutable count. No synchronization.
// WHY: Potential bug: should be conditional on Element: Sendable.
// WHEN TO REMOVE: When the type is redesigned or inference improves.
// TRACKING: unsafe-audit-findings.md Category D SP-7.
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
