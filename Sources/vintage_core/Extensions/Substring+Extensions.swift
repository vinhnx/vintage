//
//  Substring+Extensions.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Foundation
import Sweep

public extension Substring {
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
