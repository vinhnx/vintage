//
//  CommandError.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Foundation
import Chalk

public enum CommandError: Error, CustomStringConvertible {
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

    public var description: String {
        return "❗️ \(self.message, color: .red)"
    }
}
