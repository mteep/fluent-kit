// swift-tools-version:5.5
import PackageDescription

// Workaround for Xcode 13.2(.1) with Swift 5.5.2, but SwiftPM 5.5.0
#if swift(>=5.5.2)
let platforms: [SupportedPlatform] = [
    .macOS(.v10_15),
    .iOS(.v13),
    .watchOS(.v6)
]
#else
let platforms: [SupportedPlatform] = [
    .macOS(.v12),
    .iOS(.v15),
    .watchOS(.v8)
]
#endif

let package = Package(
    name: "fluent-kit",
    platforms: platforms,
    products: [
        .library(name: "FluentKit", targets: ["FluentKit"]),
        .library(name: "FluentBenchmark", targets: ["FluentBenchmark"]),
        .library(name: "FluentSQL", targets: ["FluentSQL"]),
        .library(name: "XCTFluent", targets: ["XCTFluent"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.42.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.24.0"),
        .package(url: "https://github.com/mteep/async-kit.git", branch: "xcode-on-big-sur"),
    ],
    targets: [
        .target(name: "FluentKit", dependencies: [
            .product(name: "NIOCore", package: "swift-nio"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "AsyncKit", package: "async-kit"),
            .product(name: "SQLKit", package: "sql-kit"),
        ]),
        .target(name: "FluentBenchmark", dependencies: [
            .target(name: "FluentKit"),
            .target(name: "FluentSQL"),
        ]),
        .target(name: "FluentSQL", dependencies: [
            .target(name: "FluentKit"),
            .product(name: "SQLKit", package: "sql-kit"),
        ]),
        .target(name: "XCTFluent", dependencies: [
            .target(name: "FluentKit"),
            .product(name: "NIOEmbedded", package: "swift-nio"),
        ]),
        .testTarget(name: "FluentKitTests", dependencies: [
            .target(name: "FluentBenchmark"),
            .target(name: "FluentSQL"),
            .target(name: "XCTFluent"),
        ]),
    ]
)
