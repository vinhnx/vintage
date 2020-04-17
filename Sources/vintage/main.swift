import ArgumentParser
import vintage_core

/*
 ### TODO
 + [plan] handle .package's path
 extension Package.Dependency {
 /// Add a dependency to a local package on the filesystem.
 public static func package(path: String) -> PackageDescription.Package.Dependency
 }
 + [plan] checkout checkouts-state.json > build dependencies graph > check outdated sub-dependencies too!")

 ### Done
 + [done] [plan] choose a better name
 + [done] check if resolved package file exists (Package.resolve), if not run `swift package resolve`
 + [done] modularize
 + [done] mint/brew/installation publish
 + [done] using Files and Sweep, https://github.com/JohnSundell/Releases
 + [done] plan: color output
 + [done] IMPORTANT: handle `throws` error

 */

struct Vintage: ParsableCommand {
    @Option(
        name: .shortAndLong,
        default: ".",
        help: "Path to the folder contains Swift Package manifest file (Package.swift)."
    ) var path: String

    func run() throws { try execute(path) }
}

Vintage.main()
