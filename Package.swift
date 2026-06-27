// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-sample-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // MARK: - Namespace
        .library(
            name: "Sample Primitive",
            targets: ["Sample Primitive"]
        ),

        // MARK: - Sub-namespaces
        .library(
            name: "Sample Averaging Primitives",
            targets: ["Sample Averaging Primitives"]
        ),
        .library(
            name: "Sample Accumulator Primitives",
            targets: ["Sample Accumulator Primitives"]
        ),
        .library(
            name: "Sample Batch Primitives",
            targets: ["Sample Batch Primitives"]
        ),

        // MARK: - Umbrella
        .library(
            name: "Sample Primitives",
            targets: ["Sample Primitives"]
        ),

        // MARK: - Test Support
        .library(
            name: "Sample Primitives Test Support",
            targets: ["Sample Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-comparison-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-order-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-algebra-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-witness-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-time-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Namespace
        .target(
            name: "Sample Primitive",
            dependencies: []
        ),

        // MARK: - Sub-namespaces
        .target(
            name: "Sample Averaging Primitives",
            dependencies: [
                "Sample Primitive",
                .product(name: "Time Primitive", package: "swift-time-primitives"),
                .product(name: "Witness Primitives", package: "swift-witness-primitives"),
            ]
        ),
        .target(
            name: "Sample Accumulator Primitives",
            dependencies: [
                "Sample Primitive",
                .product(name: "Algebra Monoid Primitives", package: "swift-algebra-primitives"),
            ]
        ),
        .target(
            name: "Sample Batch Primitives",
            dependencies: [
                "Sample Primitive",
                "Sample Averaging Primitives",
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Order Primitives", package: "swift-order-primitives"),
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Sample Primitives",
            dependencies: [
                "Sample Primitive",
                "Sample Averaging Primitives",
                "Sample Accumulator Primitives",
                "Sample Batch Primitives",
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Sample Primitives Test Support",
            dependencies: [
                "Sample Primitives",
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Sample Primitives Tests",
            dependencies: [
                "Sample Primitives",
                "Sample Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
