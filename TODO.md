### Goal
 + create an command-line utilities in Swift (mostly to learn-by-doing)
 + to find outdated package
 + if so, just print out
 + think `pod outdated` but for SPM
 + read `swift package update` manual

### TODO
 + check carthage logic https://github.com/Carthage/Carthage/blob/master/Source/carthage/Outdated.swift
 + write tests
 + documents
 + [plan] handle .package's path
 /// Add a dependency to a local package on the filesystem.
 public static func package(path: String) -> PackageDescription.Package.Dependency
 + [plan] checkout checkouts-state.json > build dependencies graph > check outdated sub-dependencies too!")
 + [plan] choose a better name
 
 ### Done
 + [done] modularize
 + [done] mint/brew/installation publish
 + [done] using Files and Sweep, https://github.com/JohnSundell/Releases
 + [done] plan: color output
 + [done] IMPORTANT: handle `throws` error

