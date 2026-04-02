// swift-tools-version: 6.3

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
        .library(
            name: "Sample Primitives",
            targets: ["Sample Primitives"]
        ),
        .library(
            name: "Sample Primitives Test Support",
            targets: ["Sample Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-ordering-primitives"),
        .package(path: "../swift-algebra-monoid-primitives"),
        .package(path: "../swift-witness-primitives"),
        .package(path: "../swift-time-primitives"),
    ],
    targets: [
        .target(
            name: "Sample Primitives Core",
            dependencies: [
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Ordering Primitives", package: "swift-ordering-primitives"),
                .product(name: "Algebra Monoid Primitives", package: "swift-algebra-monoid-primitives"),
                .product(name: "Witness Primitives", package: "swift-witness-primitives"),
                .product(name: "Time Primitives Core", package: "swift-time-primitives"),
            ]
        ),
        .target(
            name: "Sample Primitives",
            dependencies: [
                "Sample Primitives Core",
            ]
        ),
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
