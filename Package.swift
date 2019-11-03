// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "authz",
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
        .library(name: "authz", targets: ["authz"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.1")
    ],
    targets: [
        .target(name: "authz", dependencies: ["Vapor"]),
        .testTarget(name: "authzTests", dependencies: ["authz"]),
    ]
)
