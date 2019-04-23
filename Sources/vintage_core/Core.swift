//
//  Core.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Chalk
import Files
import Foundation
import Releases

// MARK: - Public

/// Execute parsing command
///
/// - Parameter path: path to the folder contains Swift Package manifest file (Package.swift).
/// - Throws: error, if any throwing operations occurs
public func execute(_ path: String = FileSystem().currentFolder.name) throws {
    let folder = try Folder(path: path)

    let packageResolveFile = try File(path: PackageConstant.manifestResolvedFileName)
    guard folder.contains(packageResolveFile) else {
        throw CommandError.noPackageFileFound(at: path)
    }

    let packageManifestFile = try File(path: PackageConstant.manifestFileName)
    guard folder.contains(packageManifestFile) else {
        throw CommandError.noPackageFileFound(at: path)
    }

    try packageManifestFile
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
    } catch let error as CustomStringConvertible {
        print(CommandError.rawError(error))
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
