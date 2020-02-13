// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MessagePack",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MessagePack",
            targets: ["MessagePack"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),

        // Dev dependencies
        // Install these locally so we can use "swift run <tool>"
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.44.1"),
        .package(url: "https://github.com/Realm/SwiftLint", .branch("master")), // TODO: switch to a tag once #2867 is fixed
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MessagePack",
            dependencies: []),
        .testTarget(
            name: "MessagePackTests",
            dependencies: ["MessagePack"]),
    ]
)
