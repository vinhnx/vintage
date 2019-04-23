//
//  CommandError.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Chalk
import Foundation

public enum CommandError: Error, CustomStringConvertible {
    case convertDataFromString
    case decoder
    case noMatchedPackageRepositoryURLFound
    case noPackageFileFound(at: String)
    case invalidURL(URL)
    case rawError(CustomStringConvertible)
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
        case .noPackageFileFound(let path):
            return "No package file found in current path: `\(path)`. Try running with `--help` option"
        case .invalidURL(let url):
            return "URL is not a valid URL. Expected: https, git. Got: \(url.scheme ?? "")"
        case .rawError(let error):
            return "[Error] \(error.description)"
        }
    }
    
    public var description: String {
        return "❗️ \(self.message, color: .red)"
    }
}
