extension Sample {

    /// Value witness for computing statistics over a collection of elements.
    ///
    /// Captures the operations needed for averaging and real-number projection:
    /// - `zero`: The additive identity.
    /// - `adding`: Binary addition.
    /// - `dividing`: Division by an integer count.
    /// - `project`: Project element to `Double` for floating-point computation.
    /// - `embed`: Embed `Double` result back into the element type.
    ///
    /// Static factories are provided for common types:
    /// ```swift
    /// sample.mean(using: .duration)               // Duration
    /// sample.standardDeviation(using: .real)       // Double
    /// ```
    @frozen
    public struct Averaging<Element>: Witness.`Protocol` {

        /// The additive identity element.
        public var zero: Element

        /// Binary addition operation.
        public var adding: @Sendable (Element, Element) -> Element

        /// Division by an integer count.
        public var dividing: @Sendable (Element, Int) -> Element

        /// Project element to `Double` for floating-point computation.
        public var project: @Sendable (Element) -> Double

        /// Embed `Double` result back into the element type.
        public var embed: @Sendable (Double) -> Element

        @inlinable
        public init(
            zero: Element,
            adding: @escaping @Sendable (Element, Element) -> Element,
            dividing: @escaping @Sendable (Element, Int) -> Element,
            project: @escaping @Sendable (Element) -> Double,
            embed: @escaping @Sendable (Double) -> Element
        ) {
            self.zero = zero
            self.adding = adding
            self.dividing = dividing
            self.project = project
            self.embed = embed
        }
    }
}

// MARK: - Sendable

extension Sample.Averaging: Sendable where Element: Sendable {}

// MARK: - Static factories

extension Sample.Averaging where Element == Duration {

    /// Averaging witness for `Duration`.
    @inlinable
    public static var duration: Self {
        .init(
            zero: .zero,
            adding: { $0 + $1 },
            dividing: { $0 / $1 },
            project: { $0.inSeconds },
            embed: { .seconds($0) }
        )
    }
}

extension Sample.Averaging where Element == Double {

    /// Averaging witness for `Double`.
    @inlinable
    public static var real: Self {
        .init(
            zero: 0,
            adding: { $0 + $1 },
            dividing: { $0 / Double($1) },
            project: { $0 },
            embed: { $0 }
        )
    }
}

extension Sample.Averaging where Element == Int {

    /// Averaging witness for `Int` (integer division).
    @inlinable
    public static var integer: Self {
        .init(
            zero: 0,
            adding: { $0 + $1 },
            dividing: { $0 / $1 },
            project: { Double($0) },
            embed: { Int($0) }
        )
    }
}

extension Sample.Averaging where Element == UInt64 {

    /// Averaging witness for `UInt64`.
    @inlinable
    public static var natural: Self {
        .init(
            zero: 0,
            adding: { $0 + $1 },
            dividing: { $0 / UInt64($1) },
            project: { Double($0) },
            embed: { UInt64($0) }
        )
    }
}
