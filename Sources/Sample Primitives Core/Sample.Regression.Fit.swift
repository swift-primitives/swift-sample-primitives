//
//  Sample.Regression.Fit.swift
//  swift-sample-primitives
//
//  Result of an ordinary least-squares linear regression.
//

extension Sample.Regression {
    /// Result of an ordinary least-squares linear regression: y ≈ slope·x + intercept.
    ///
    /// Contains the fitted parameters and goodness-of-fit statistics.
    public struct Fit: Sendable, Hashable {
        /// The slope of the fitted line.
        public let slope: Double

        /// The y-intercept of the fitted line.
        public let intercept: Double

        /// Coefficient of determination (R²).
        ///
        /// Ranges from 0 to 1. Higher values indicate a better fit:
        /// - R² > 0.95: strong fit
        /// - R² > 0.85: good fit
        /// - R² < 0.80: weak fit
        ///
        /// Returns 0 when all response values are identical (no variance
        /// to explain). This is the standard convention — the model is
        /// trivially "perfect" but explains no variance because there is none.
        public let rSquared: Double

        /// Mean squared error of the residuals.
        ///
        /// Uses n-2 degrees of freedom (Bessel's correction for 2 parameters).
        public let meanSquaredError: Double

        public init(
            slope: Double,
            intercept: Double,
            rSquared: Double,
            meanSquaredError: Double
        ) {
            self.slope = slope
            self.intercept = intercept
            self.rSquared = rSquared
            self.meanSquaredError = meanSquaredError
        }
    }
}
