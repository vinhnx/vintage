# Goal:
 >> create a swift CLI tool
 + to find outdated package
 + if so, just print out
 + think `pod outdated`
 + read `swift package update` manual

# TODO:
 + check carthage logic https://github.com/Carthage/Carthage/blob/master/Source/carthage/Outdated.swift
 + write tests
 + mint/brew/installation publish
 + documents
 + [plan] handle .package's path
 /// Add a dependency to a local package on the filesystem.
 public static func package(path: String) -> PackageDescription.Package.Dependency
 + [plan] checkout checkouts-state.json > build dependencies graph > check outdated sub-dependencies too!")
 + [done] using Files and Sweep, https://github.com/JohnSundell/Releases
 + [done] plan: color output
 + [done] IMPORTANT: handle `throws` error

