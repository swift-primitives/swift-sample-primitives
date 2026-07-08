import Sample_Primitives
import Testing

@Suite
struct `Sample Batch Median Absolute Deviation Tests` {

    // MARK: - MAD

    @Test
    func `empty batch`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.medianAbsoluteDeviation == nil)
    }

    @Test
    func `single element`() {
        let batch = Sample.Batch([42.0])
        #expect(batch.medianAbsoluteDeviation == 0.0)
    }

    @Test
    func `uniform values`() {
        let batch = Sample.Batch([7.0, 7.0, 7.0, 7.0, 7.0])
        #expect(batch.medianAbsoluteDeviation == 0.0)
    }

    @Test
    func `known distribution`() {
        // Sorted: [1, 2, 3, 4, 5]. Median = 3.
        // Deviations from median: |1-3|=2, |2-3|=1, |3-3|=0, |4-3|=1, |5-3|=2
        // Sorted deviations: [0, 1, 1, 2, 2]. Median of deviations = 1.
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.medianAbsoluteDeviation == 1.0)
    }

    @Test
    func `with outlier`() {
        // Sorted: [1, 2, 3, 4, 100]. Median = 3.
        // Deviations: |1-3|=2, |2-3|=1, |3-3|=0, |4-3|=1, |100-3|=97
        // Sorted deviations: [0, 1, 1, 2, 97]. Median = 1.
        // MAD is 1.0 — robust against the outlier 100.
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 100.0])
        #expect(batch.medianAbsoluteDeviation == 1.0)
    }

    @Test
    func `duration convenience`() {
        let batch = Sample.Batch<Duration>([
            .seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(5),
        ])
        #expect(batch.medianAbsoluteDeviation == .seconds(1))
    }

    // MARK: - Outlier Count

    @Test
    func `outlier count empty`() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.outlierCount() == nil)
    }

    @Test
    func `outlier count uniform`() {
        let batch = Sample.Batch([5.0, 5.0, 5.0, 5.0, 5.0])
        #expect(batch.outlierCount() == 0)
    }

    @Test
    func `outlier count no outliers`() {
        // [1, 2, 3, 4, 5]. MAD = 1. Threshold = 3 * 1 = 3.
        // Max deviation from median (3) is 2. 2 < 3, so 0 outliers.
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.outlierCount() == 0)
    }

    @Test
    func `outlier count with outlier`() {
        // [1, 2, 3, 4, 100]. MAD = 1. Threshold = 3 * 1 = 3.
        // 100 is 97 away from median 3. 97 > 3 → 1 outlier.
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 100.0])
        #expect(batch.outlierCount() == 1)
    }

    @Test
    func `outlier count custom threshold`() {
        // [1, 2, 3, 4, 5]. MAD = 1. Threshold = 1.5 * 1 = 1.5.
        // Deviations: 2, 1, 0, 1, 2. Values 1 and 5 have deviation 2 > 1.5 → 2 outliers.
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.outlierCount(threshold: 1.5) == 2)
    }

    @Test
    func `outlier count duration`() {
        let batch = Sample.Batch<Duration>([
            .seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(100),
        ])
        #expect(batch.outlierCount() == 1)
    }
}
