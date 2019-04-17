//
//  String+Extensions.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Foundation
import Sweep
import Releases

public extension String {
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
