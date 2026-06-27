import Sample_Primitives
import Testing

@Suite
struct SampleAveragingTests {

    @Test
    func meanDouble() {
        let batch = Sample.Batch([1.0, 2.0, 3.0, 4.0, 5.0])
        #expect(batch.mean == 3.0)
    }

    @Test
    func meanInt() {
        let batch = Sample.Batch([10, 20, 30])
        #expect(batch.mean == 20)
    }

    @Test
    func meanEmptyBatch() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.mean == nil)
    }

    @Test
    func sumDouble() {
        let batch = Sample.Batch([1.0, 2.0, 3.0])
        #expect(batch.sum == 6.0)
    }

    @Test
    func meanWithExplicitWitness() {
        let batch = Sample.Batch([10.0, 20.0, 30.0])
        let result = batch.mean(using: .real)
        #expect(result == 20.0)
    }

    @Test
    func standardDeviationDouble() {
        let batch = Sample.Batch([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0])
        let stddev = batch.standardDeviation
        #expect(stddev != nil)
        // mean = 5.0, sample variance (Bessel's) = 32/7, stddev = sqrt(32/7) ≈ 2.138
        let expected = (32.0 / 7.0).squareRoot()
        #expect(abs(stddev! - expected) < 0.001)
    }

    @Test
    func standardDeviationSingleElement() {
        let batch = Sample.Batch([42.0])
        #expect(batch.standardDeviation == nil)
    }

    @Test
    func standardDeviationEmpty() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.standardDeviation == nil)
    }

    @Test
    func averagingWitnessProtocolConformance() {
        let averaging = Sample.Averaging<Double>.real
        let sum = averaging.adding(3.0, 4.0)
        #expect(sum == 7.0)
        let divided = averaging.dividing(10.0, 2)
        #expect(divided == 5.0)
        #expect(averaging.zero == 0.0)
    }

    @Test
    func averagingUInt64() {
        let batch = Sample.Batch<UInt64>([10, 20, 30], sortedBy: .ascending)
        let result = batch.mean(using: .natural)
        #expect(result == 20)
    }
}
