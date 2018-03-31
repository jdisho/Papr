//
//  ResourceType.swift
//  TinyNetworking
//
//  Created by Joan Disho on 29.03.18.
//

import Foundation

public protocol ResourceType {
    var baseURL: URL { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: [String: String] { get }
}
