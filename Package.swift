// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StreamChatTestHelpers",
    products: [
        .library(
            name: "StreamChatTestHelpers",
            targets: ["StreamChatTestHelpers"]),
        .library(
            name: "StreamChatMockServer",
            targets: ["StreamChatMockServer"])
    ],
    dependencies: [
        .package(name: "Difference", url: "https://github.com/krzysztofzablocki/Difference.git", .exact("1.0.1")),
        .package(name: "Swifter", url: "https://github.com/httpswift/swifter", .exact("1.5.0"))
    ],
    targets: [
        .target(
            name: "StreamChatTestHelpers",
            dependencies: [
                .product(name: "Difference", package: "Difference")
            ],
            path: "Sources/TestHelpers"),
        .target(name: "StreamChatMockServer",
                dependencies: [
                    .product(name: "Swifter", package: "Swifter"),
                    .target(name: "StreamChatTestHelpers")
                ],
                path: "Sources/MockServer")
    ]
)