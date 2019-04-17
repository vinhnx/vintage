import Foundation
import Chalk
import CLISpinner
import Commander
import Files
import Releases
import Sweep

// NOTE: check TODO.md in root folder for TODOs

/**
 Package Model
 */
struct RootState: Decodable {
    let object: Object
}

struct Object: Decodable {
    let pins: [Pin]
}

struct Pin: Decodable {
    let package: String
    let repositoryURL: String
    let state: State
}

struct State: Decodable {
    let branch: String?
    let revision: String
    let version: String?
}

/**
 Constants
 */
struct PackageConstant {
    static let manifestResolvedFileName = "Package.resolved"
    static let manifestFileName = "Package.swift"
}

struct PackageDependencyConstant {
    static let rootToken = ".package"
    static let URLStartToken = "url:\""
    static let URLEndToken = "\","
    static let gitExtension = ".git"
}

/**
 Extensions
 */
extension String {
    var toVersion: Version? {
        do {
            return try Version(string: self)
        } catch {
            return nil
        }
    }

    var toIdentifier: Identifier {
        return Identifier(stringLiteral: self)
    }

    var toTerminator: Terminator {
        return Terminator(stringLiteral: self)
    }

    func scanPackage(handler: @escaping Matcher.Handler) {
        // .package(url: "https://github.com/JohnSundell/Sweep", from: "0.1.0"),
        self.scan(using: [
            Matcher(identifiers: [PackageDependencyConstant.rootToken.toIdentifier],
                    terminators: ["\n", .end],
                    handler: handler)
        ])
    }

    func scanPackageURL(completion: @escaping (Substring) -> Void) {
        self.scanPackage { substring, _ in
            substring.scanPackageURL { innerSubstring in
                completion(innerSubstring)
            }
        }
    }
}

extension Substring {
    var gitURL: URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: self.gitURLString)!
        // swiftlint:disable:previous force_unwrapping
    }

    var gitURLString: String {
        var result = self.toString

        // append `.git` extension if needed
        if result.hasSuffix(PackageDependencyConstant.gitExtension) == false {
            result.append(PackageDependencyConstant.gitExtension)
        }

        return result
    }

    var toString: String {
        return String(self)
    }

    func scanPackageURL(completion: @escaping (Substring) -> Void) {
        // url: "https://github.com/JohnSundell/Sweep"
        self.scan(using: [
            Matcher(identifier: PackageDependencyConstant.URLStartToken.toIdentifier,
                    terminator: PackageDependencyConstant.URLEndToken.toTerminator,
                    handler: { substring, _ in
                        completion(substring)
            })
        ])
    }
}

extension URL {
    var isValidRemoteURL: Bool {
        guard let scheme = self.scheme else { return false }
        return ["http", "https", "git"].contains(scheme)
    }

    func fetchVersionsFromRemoteGitURL() -> [Version] {
        guard isValidRemoteURL else {
            print(CommandError.invalidURL(self).description)
            return []
        }

        do {
            return try Releases.versions(for: self)
        } catch {
            print(CommandError.rawError(error, #line))
            return []
        }
    }
}

extension File {
    func trimmedWhiteSpacesContent() throws -> String {
        return try self.readAsString().replacingOccurrences(of: " ", with: "")
    }
}

/**
 Custom Error
 */
enum CommandError: Error, CustomStringConvertible {
    case convertDataFromString
    case decoder
    case noMatchedPackageRepositoryURLFound
    case noPackageManifestFileFound(String)
    case invalidURL(URL)
    case rawError(Error, Int)
}

extension CommandError {
    var message: String {
        switch self {
        case .convertDataFromString:
            return "Failed to convert data from string"
        case .decoder:
            return "Failed to decode JSON from data"
        case .noMatchedPackageRepositoryURLFound:
            return "No matched package repository URL found"
        case .noPackageManifestFileFound(let path):
            return "No package manifest file found in current path: `\(path)`. Try running with `-p` option, example: `package_outdated run -p Dependencies`"
        case .invalidURL(let url):
            return "URL is not a valid URL. Expected: https, git. Got: \(url.scheme ?? "")"
        case .rawError(let error, let line):
            return "[Error line #\(line)] \(error.localizedDescription)"
        }
    }

    var description: String {
        return "❗️ \(self.message, color: .red)"
    }
}

/**
 Handling
 */

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

/// Execute parsing command
///
/// - Parameter path: path to the folder contains Swift Package manifest file (Package.swift).
/// - Throws: error, if any throwing operations occurs
func execute(_ path: String = FileSystem().currentFolder.name) throws {
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

/// Parse and output print from comparing versions
///
/// - Parameters:
///   - substring: parsed substring
///   - path: path to the folder contains Swift Package manifest file (Package.swift).
func parse(_ substring: Substring, path: String) {
    do {
        let url = substring.gitURL
        let spinner = Spinner(pattern: .dots)
        spinner.start()
        let releases = try Releases.versions(for: url)
        let localVersion = try findVersionTagForPackage(substring.toString, path: path).toVersion
        outputPrint(url: url, releases: releases, localVersion: localVersion)
        spinner.succeed()
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

/**
 Commands
 */
let pathOption = Option("path", default: ".", flag: "p", description: "Path to the folder contains Swift Package manifest file (Package.swift).")
let pathCommand = command(pathOption) { path in
    try execute(path)
}

let group = Group {
    $0.addCommand("run", "Check project's Package dependencies' local version with remote latest version.", pathCommand)
}

group.run()
