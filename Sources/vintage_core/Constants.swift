//
//  Constants.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//

import Foundation

public struct PackageConstant {
    public static let manifestResolvedFileName = "Package.resolved"
    public static let manifestFileName = "Package.swift"
}

public struct PackageDependencyConstant {
    public static let rootToken = ".package"
    public static let URLStartToken = "url:\""
    public static let URLEndToken = "\","
    public static let gitExtension = ".git"
}
