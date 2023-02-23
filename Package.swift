// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-nio-benchmarks",
    platforms: [.macOS(.v13)],
    products: [
    ],

    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark", branch: "export-histograms"),
        .package(url: "https://github.com/apple/swift-nio", .upToNextMajor(from: "2.42.0")),
    ],

    targets: [
        .executableTarget(
            name: "TCPBenchmarks",
            dependencies: [
                .product(name: "BenchmarkSupport", package: "package-benchmark"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio")
            ],
            path: "Benchmarks/TCPBenchmarks"
        ),
    ]
)
