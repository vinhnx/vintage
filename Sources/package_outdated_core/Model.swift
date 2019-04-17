//
//  Model.swift
//  package_outdated_core
//
//  Created by Vinh Nguyen on 17/4/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation

public struct RootState: Decodable {
    public let object: Object
}

public struct Object: Decodable {
    public let pins: [Pin]
}

public struct Pin: Decodable {
    public let package: String
    public let repositoryURL: String
    public let state: State
}

public struct State: Decodable {
    public let branch: String?
    public let revision: String
    public let version: String?
}
