// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNBTCodable",
    products: [
        .library(
            name: "SwiftNBTCodable",
            targets: ["SwiftNBTCodable"]),
    ],
    dependencies: [
        .package(name: "Gzip", url: "https://github.com/1024jp/GzipSwift.git", from: "5.1.1"),
    ],
    targets: [
        .target(
            name: "SwiftNBTCodable",
            dependencies: ["Gzip"]),
        .testTarget(
            name: "SwiftNBTCodableTests",
            dependencies: ["SwiftNBTCodable"]),
    ]
)
