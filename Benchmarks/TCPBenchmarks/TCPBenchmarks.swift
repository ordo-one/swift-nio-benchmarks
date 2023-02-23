//
// Copyright (c) 2022 Ordo One AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
//
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//

import BenchmarkSupport
import Dispatch

@main
extension BenchmarkRunner {}

// swiftlint disable: attributes
@_dynamicReplacement(for: registerBenchmarks)
func benchmarks() {
    Benchmark.defaultConfiguration = .init(metrics: BenchmarkMetric.all,
                                           throughputScalingFactor: .kilo,
                                           desiredDuration: .seconds(2))

    Benchmark("TCPThroughputBenchmark.small") { benchmark in

        let bench = TCPThroughputBenchmark(messages: 10_000, messageSize: 20)

        do {
            try bench.setUp()

            benchmark.startMeasurement()
            blackHole(try bench.run())
            benchmark.stopMeasurement()
        } catch {
            fatalError("bench.run threw \(error)")
        }
        bench.tearDown()
    }

    Benchmark("TCPThroughputBenchmark.medium") { benchmark in

        let bench = TCPThroughputBenchmark(messages: 10_000, messageSize: 500)

        do {
            try bench.setUp()

            benchmark.startMeasurement()
            blackHole(try bench.run())
            benchmark.stopMeasurement()
        } catch {
            fatalError("bench.run threw \(error)")
        }
        bench.tearDown()
    }

    Benchmark("TCPThroughputBenchmark.large") { benchmark in

        let bench = TCPThroughputBenchmark(messages: 10_000, messageSize: 16*1024)

        do {
            try bench.setUp()

            benchmark.startMeasurement()
            blackHole(try bench.run())
            benchmark.stopMeasurement()
        } catch {
            fatalError("bench.run threw \(error)")
        }
        bench.tearDown()
    }

}
