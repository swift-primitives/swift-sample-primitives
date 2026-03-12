import Testing
import Sample_Primitives

@Suite
struct SampleBatchCoefficientOfVariationTests {

    @Test
    func emptyBatch() {
        let batch = Sample.Batch<Double>([], sortedBy: .ascending)
        #expect(batch.coefficientOfVariation == nil)
    }

    @Test
    func singleElement() {
        let batch = Sample.Batch([42.0])
        #expect(batch.coefficientOfVariation == nil)
    }

    @Test
    func uniformValues() {
        let batch = Sample.Batch([5.0, 5.0, 5.0, 5.0, 5.0])
        #expect(batch.coefficientOfVariation == 0.0)
    }

    @Test
    func knownDistribution() {
        // Values: 10, 20, 30, 40, 50
        // Mean = 30. Sum of squared deviations = 1000.
        // Sample variance (n-1) = 250. StdDev = sqrt(250) ≈ 15.811.
        // CV = 15.811 / 30 * 100 ≈ 52.705%.
        let batch = Sample.Batch([10.0, 20.0, 30.0, 40.0, 50.0])
        let cv = batch.coefficientOfVariation!
        #expect(abs(cv - 52.705) < 0.01)
    }

    @Test
    func lowVariance() {
        // Tight cluster: CV should be < 5%
        let batch = Sample.Batch([100.0, 101.0, 99.0, 100.5, 99.5])
        let cv = batch.coefficientOfVariation!
        #expect(cv < 5.0)
    }

    @Test
    func durationConvenience() {
        let batch = Sample.Batch<Duration>([.seconds(1), .seconds(1), .seconds(1)])
        #expect(batch.coefficientOfVariation == 0.0)
    }

    @Test
    func durationWithVariance() {
        let batch = Sample.Batch<Duration>([
            .seconds(10), .seconds(20), .seconds(30), .seconds(40), .seconds(50),
        ])
        let cv = batch.coefficientOfVariation!
        #expect(cv > 20.0)
    }

    @Test
    func zeroMean() {
        let batch = Sample.Batch([-1.0, 0.0, 1.0])
        #expect(batch.coefficientOfVariation == nil)
    }

    @Test
    func genericWitness() {
        let batch = Sample.Batch([100, 200, 300, 400, 500])
        let cv = batch.coefficientOfVariation(using: .integer)
        #expect(cv != nil)
        #expect(cv! > 0)
    }
}
