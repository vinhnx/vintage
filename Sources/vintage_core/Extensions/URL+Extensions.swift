//
//  URL+Extensions.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Foundation
import Releases

public extension URL {
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
        } catch let error as CustomStringConvertible {
            print(CommandError.rawError(error))
            return []
        }
    }
}
