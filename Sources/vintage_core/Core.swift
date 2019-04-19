//
//  Core.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Foundation
import Files
import Chalk
import Releases

/*
version logic:


 .from: accept next major

 The following code specifies any version of the dependency, starting at 1.1.3 and less than 2.0.0:
     .package(url: "https://github.com/...git", from: "1.1.3")

 ...: range
 If you want specify a minimum and maximum version for one dependency, you can use a range:
     .package(url: "https://github.com/...git", "1.1.0" ... "1.2.1")

     .exact: exactly
 Use the following if you’re interested in an exact version of a dependency:
     .package(url: "https://github.com/...git", .exact("1.2.3"))

 All of these version - specific variations also support beta - versioning.For example:
     .package(url: "https://github.com/...git", from: "1.1.3-beta.4")

     .branch: git branch
 You can also lock the dependency to a specific branch in git.This is useful if a feature or fix is not yet released:
     .package(url: "https://github.com/...git", .branch("bugfix/issue-121"))

     .revision: hash
 Finally, you can specify a commit by its hash:
     .package(url: "https://github.com/...git", .revision("04136e97a73b826528dd077c3ebab07d9f8f48e2"))

*/

// MARK: - Public

/// Execute parsing command
///
/// - Parameter path: path to the folder contains Swift Package manifest file (Package.swift).
/// - Throws: error, if any throwing operations occurs
public func execute(_ path: String = FileSystem().currentFolder.name) throws {
    let folder = try Folder(path: path)
    let packageFile = folder.files.first { $0.name == PackageConstant.manifestFileName }
    guard let packageManifest = packageFile else {
        throw CommandError.noPackageManifestFileFound(path)
    }

    try packageManifest
        .trimmedWhiteSpacesContent()
        .scanPackageURL { substring in
            parse(substring, path: path)
    }
}

// MARK: - Private

/// Find version tag for a given Package
///
/// - Parameters:
///   - packageURL: package remote URL (TODO: handle local package)
///   - path: path to the folder contains Swift Package manifest file (Package.swift).
/// - Returns: version tag ofr the given Package dependency
/// - Throws: error, if any throwing operations occurs
func findVersionTagForPackage(_ packageURL: String, path: String) throws -> String {
    let folder = try Folder(path: path)
    let file = try folder.file(atPath: PackageConstant.manifestResolvedFileName)
    let content = try file.readAsString()

    guard let data = content.data(using: .utf8) else {
        throw CommandError.convertDataFromString
    }

    let result = try JSONDecoder().decode(RootState.self, from: data)
    let package = result.object.pins.first { $0.repositoryURL == packageURL }
    guard let unwrappedPackage = package else {
        throw CommandError.noMatchedPackageRepositoryURLFound
    }

    return unwrappedPackage.state.version ?? ""
}

/// Parse and output print from comparing versions
///
/// - Parameters:
///   - substring: parsed substring
///   - path: path to the folder contains Swift Package manifest file (Package.swift).
func parse(_ substring: Substring, path: String) {
    do {
        let url = substring.gitURL
        let releases = try Releases.versions(for: url)
        let localVersion = try findVersionTagForPackage(substring.toString, path: path).toVersion
        outputPrint(url: url, releases: releases, localVersion: localVersion)
    } catch {
        print(CommandError.rawError(error, #line))
    }
}

/// Color code from comparing version
///
/// - Parameters:
///   - lhs: left hand side version
///   - rhs: right hand side version
/// - Returns: color code
func colorCode(lhs: Version, rhs: Version) -> Color {
    return lhs == rhs ? .green : .red
}

/// Output print to terminal
///
/// - Parameters:
///   - url: path to the folder contains Swift Package manifest file (Package.swift).
///   - releases: released versions
///   - localVersion: local version
func outputPrint(url: URL, releases: [Version], localVersion: Version?) {
    print("📦 " + "\(url.absoluteString, style: .bold)")
    guard let latestVersion = (releases.last?.string ?? "").toVersion else { return }

    var color: Chalk.Color = .white
    localVersion.flatMap { local in
        color = colorCode(lhs: local, rhs: latestVersion)
        print("> 🏷  local version: \(local, color: color)")
    }

    print("> ☁️  latest version: \(latestVersion, color: color)")
}
