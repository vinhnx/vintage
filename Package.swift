// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "package_outdated",
    products: [
        .executable(name: "package_outdated", targets: ["package_outdated"]),
        .library(name: "package_outdated_core", targets: ["package_outdated_core"])
    ],
    dependencies: [
        .package(url: "git@github.com:JohnSundell/Sweep.git", from: "0.1.0"),
        .package(url: "git@github.com:JohnSundell/Files.git", from: "3.0.0"),
        .package(url: "git@github.com:JohnSundell/Releases.git", from: "2.0.0"),
        .package(url: "git@github.com:kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/mxcl/Chalk.git", from: "0.1.0"),
        .package(url: "https://github.com/kiliankoe/CLISpinner", from: "0.3.6")
    ],
    targets: [
        .target(name: "package_outdated_core", dependencies: ["Sweep", "Files", "Releases", "Commander", "Chalk", "CLISpinner"], path: "Sources/package_outdated_core"),
        .target(name: "package_outdated", dependencies: ["package_outdated_core"]),
    ]
)
