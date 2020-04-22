// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MessagePackTools",
    products: [
    ],
    dependencies: [
        // Dev dependencies
        // Install these locally so we can use "swift run <tool>"
                .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.44.1"),
        .package(url: "https://github.com/Realm/SwiftLint", .branch("master")), // TODO: switch to a tag once #2867 is fixed
    ],
    targets: [
    ]
)