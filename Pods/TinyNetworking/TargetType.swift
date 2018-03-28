//
//  TargetType.swift
//  TinyNetworking
//
//  Created by Joan Disho on 29.03.18.
//

import Foundation

public protocol TargetType {
    var baseURL: URL { get }
    var endpoint: String { get }
    var resource: ResourceType { get }
    var parameters: [String: String] { get }
    var headers: [String: String] { get }
}
