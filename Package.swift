// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "package_outdated",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/JohnSundell/Sweep", from: "0.1.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "3.0.0"),
        .package(url: "https://github.com/JohnSundell/Releases", from: "2.0.0"),
        .package(url: "https://github.com/kylef/Commander", from: "0.8.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "package_outdated",
            dependencies: ["Sweep", "Files", "Releases", "Commander", "Rainbow"]
        ),
        .testTarget(
            name: "package_outdatedTests",
            dependencies: ["package_outdated"]
        )
    ]
)
