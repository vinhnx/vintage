import Commander
import vintage_core

// NOTE: check TODO.md in root folder for TODOs
/*
 ### Goal
 + create an command-line utilities in Swift (mostly to learn-by-doing)
 + to find outdated package
 + if so, just print out
 + think `pod outdated` but for SPM
 + read `swift package update` manual

 ### TODO
 + check if resolved package file exists (Package.resolve), if not run `swift package resolve`
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

 */

let pathOption = Option("path",
                        default: ".",
                        flag: "p",
                        description: "Path to the folder contains Swift Package manifest file (Package.swift).")

let pathCommand = command(pathOption) { path in
    try execute(path)
}

let group = Group {
    $0.addCommand("run", "Check project's Package dependencies' local version with remote latest version.", pathCommand)
}

group.run()
