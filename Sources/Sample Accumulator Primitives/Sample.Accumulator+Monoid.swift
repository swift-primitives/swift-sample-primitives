@_exported public import Algebra_Monoid_Primitives
public import Sample_Primitive

extension Sample.Accumulator {

    /// Commutative monoid witness for accumulator merging.
    ///
    /// The monoid (Accumulator, merged(with:), .empty) satisfies:
    /// - Identity: `a.merged(with: .empty) == a`
    /// - Associativity: `a.merged(with: b).merged(with: c) == a.merged(with: b.merged(with: c))`
    /// - Commutativity: `a.merged(with: b) == b.merged(with: a)`
    @inlinable
    public static var monoid: Algebra.Monoid<Self>.Commutative {
        .init(
            monoid: .init(
                identity: .empty,
                combining: { $0.merged(with: $1) }
            )
        )
    }
}
