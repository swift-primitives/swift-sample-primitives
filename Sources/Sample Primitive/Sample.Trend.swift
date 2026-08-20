// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Sample {
    /// Statistical evidence about monotonic trend in an ordered sample.
    ///
    /// This value deliberately carries evidence rather than an interpretation.
    /// A consumer decides which significance threshold and direction matter in
    /// its own domain.
    public struct Trend: Sendable, Hashable {
        /// The Mann–Kendall S statistic.
        public let statistic: Int

        /// The tie-corrected variance of ``statistic``.
        public let variance: Double

        /// The continuity-corrected standard score.
        public let standardized: Double

        /// The number of finite observations included in the calculation.
        public let included: Int

        /// The number of non-finite observations excluded from the calculation.
        public let excluded: Int

        /// The number of distinct values that occurred more than once.
        public let ties: Int

        init(
            statistic: Int,
            variance: Double,
            standardized: Double,
            included: Int,
            excluded: Int,
            ties: Int
        ) {
            self.statistic = statistic
            self.variance = variance
            self.standardized = standardized
            self.included = included
            self.excluded = excluded
            self.ties = ties
        }
    }
}
