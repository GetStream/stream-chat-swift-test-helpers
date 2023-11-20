// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StreamSwiftTestHelpers",
    platforms: [
        .iOS(.v12), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "StreamSwiftTestHelpers",
            targets: ["StreamSwiftTestHelpers"]
        )
    ],
    dependencies: [
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            .exact("1.11.1")
        )
    ],
    targets: [
        .target(
            name: "StreamSwiftTestHelpers",
            dependencies: [
                .product(
                    name: "SnapshotTesting",
                    package: "SnapshotTesting"
                )
            ],
            path: "Sources/TestHelpers"
        )
    ]
)
