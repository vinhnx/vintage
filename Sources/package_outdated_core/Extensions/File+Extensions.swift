//
//  File+Extensions.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Foundation
import Files

public extension File {
    func trimmedWhiteSpacesContent() throws -> String {
        return try self.readAsString().replacingOccurrences(of: " ", with: "")
    }
}
