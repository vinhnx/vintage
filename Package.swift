// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vintage",
    products: [
        .executable(name: "vintage", targets: ["vintage"]),
        .library(name: "vintage_core", targets: ["vintage_core"])
    ],
    dependencies: [
        .package(url: "git@github.com:JohnSundell/Sweep.git", from: "0.1.0"),
        .package(url: "git@github.com:JohnSundell/Files.git", from: "3.0.0"),
        .package(url: "git@github.com:JohnSundell/Releases.git", from: "2.0.0"),
        .package(url: "git@github.com:kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/mxcl/Chalk.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "vintage_core", dependencies: ["Sweep", "Files", "Releases", "Commander", "Chalk"], path: "Sources/vintage_core"),
        .target(name: "vintage", dependencies: ["vintage_core"]),
    ]
)
