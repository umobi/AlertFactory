// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlertFactory",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .macOS(.v10_15), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "AlertFactory",
            targets: ["AlertFactory"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AlertFactory",
            dependencies: []),
        .testTarget(
            name: "AlertFactoryTests",
            dependencies: ["AlertFactory"]),
    ]
)
