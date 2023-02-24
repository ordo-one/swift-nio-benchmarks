//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2019 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Dispatch
import BenchmarkSupport

protocol NIOBenchmark: AnyObject {
    func setUp() throws
    func tearDown()
    func run() throws -> Int
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
protocol AsyncBenchmark: AnyObject, Sendable {
    func setUp() async throws
    func tearDown()
    func run() async throws -> Int
}

func measureAndPrint<B: NIOBenchmark>(desc: String, benchmark bench: B) throws {
    Benchmark(desc) { benchmarkContext in
//        print("RUNNING \(desc)")
        do {
            try bench.setUp()
            defer {
                bench.tearDown()
            }
            benchmarkContext.startMeasurement()
            blackHole(try bench.run())
            benchmarkContext.stopMeasurement()
        } catch {}
    }
}

func measureAndPrint<B: AsyncBenchmark>(desc: String, benchmark bench: B) throws {
    Benchmark(desc) { benchmarkContext in
//        print("RUNNING \(desc)")
        do {
            try await bench.setUp()
            defer {
                bench.tearDown()
            }
            benchmarkContext.startMeasurement()
            blackHole(try await bench.run())
            benchmarkContext.stopMeasurement()
        } catch {}
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public func measureAndPrint(desc: String, fn: @escaping () async throws -> Int) rethrows -> Void {

    Benchmark(desc) { benchmarkContext in
//        print("RUNNING \(desc)")
        do {
            benchmarkContext.startMeasurement()
            blackHole(try await fn())
            benchmarkContext.stopMeasurement()
        } catch {}
    }
}

/*
func measureAndPrint<B: NIOBenchmark>(desc: String, benchmark bench: B) throws {
    try bench.setUp()
    defer {
        bench.tearDown()
    }
    try measureAndPrint(desc: desc) {
        return try bench.run()
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
protocol AsyncBenchmark: AnyObject, Sendable {
    func setUp() async throws
    func tearDown()
    func run() async throws -> Int
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
func measureAndPrint<B: AsyncBenchmark>(desc: String, benchmark bench: B) throws {
    let group = DispatchGroup()
    group.enter()
    Task {
        do {
            try await bench.setUp()
            defer {
                bench.tearDown()
            }
            try await measureAndPrint(desc: desc) {
                return try await bench.run()
            }
        }
        group.leave()
    }

    group.wait()
}
*/
