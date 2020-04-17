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
public func execute(_ path: String) throws {
    // IMPORTANT: first, we check for "Package.swift" (if no package manifest file found,
    // meaning this is not a Swift package manager)
    let manifestFile = try file(path, name: PackageConstant.manifestFileName)
    try scan(manifestFile, path: path)
}

// MARK: - Private

func scan(_ manifestFile: File, path: String) throws {
    try manifestFile
        .trimmedWhiteSpacesContent()
        .scanPackageURL { substring in
            parse(substring, path: path)
        }
}

/// Return file name at a given path
///
/// - Parameters:
///   - path: path to find File
///   - name: the name of the File to search
/// - Returns: file at a given path
/// - Throws: error, if any throwing operations occurs
@discardableResult
func file(_ path: String, name: String) throws -> File {
    let folder = try Folder(path: path)
    let file = try File(path: path.appending("/\(name)"))
    guard folder.contains(file) else {
        throw CommandError.noPackageFileFound(at: path)
    }

    return file
}

/// Find version tag for a given Package
///
/// - Parameters:
///   - packageURL: package remote URL (TODO: handle local package)
///   - path: path to the folder contains Swift Package manifest resolve file (Package.resolve).
/// - Returns: version tag for the given Package dependency
/// - Throws: error, if any throwing operations occurs
func findVersionTagForPackage(_ packageURL: String, path: String) throws -> String {
    let packageResolveFile = try file(path, name: PackageConstant.manifestResolvedFileName)
    let content = try packageResolveFile.readAsString()
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
///   - localVersion: local version
///   - remoteVersion: remote version
/// - Returns: color code
func colorCode(localVersion: Version, remoteVersion: Version) -> Color {
    let color: Color
    let versionComparisionResult = localVersion.string.compare(remoteVersion.string,
                                                               options: .numeric)

    switch versionComparisionResult {
    case .orderedSame,
         .orderedDescending: // local version can not be higher than remote version
        color = .white
    case .orderedAscending:
        color = .red
    }

    return color
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
        color = colorCode(localVersion: local, remoteVersion: latestVersion)
        print("> 🏷  local version: \(local, color: color)")
    }

    print("> ☁️  latest version: \(latestVersion, color: color)")
}
