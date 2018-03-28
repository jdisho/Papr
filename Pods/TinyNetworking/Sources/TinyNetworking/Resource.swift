//
//  Resource.swift
//  TinyNetworking
//
//  Created by Joan Disho on 02.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public protocol ResourceType {
    var method: HttpMethod<Data?> { get }
    var decode: (Data) throws -> Decodable? { get }
}

public struct Resource<Body, Response>: ResourceType {
    public let method: HttpMethod<Data?>
    public let decode: (Data) throws -> Decodable?
}

public extension Resource where Body: Encodable, Response: Decodable {
    init(_ method: HttpMethod<Body> = .get) {
        self.method =  method.map { try? JSONEncoder().encode($0) }
        self.decode = { try JSONDecoder().decode(Response.self,from: $0) }
    }

}

public extension Resource where Body == Void, Response: Decodable {
    init(_ method: HttpMethod<Body> = .get) {
        self.method =  method.map { _ in return nil }
        self.decode = { try JSONDecoder().decode(Response.self, from: $0) }
    }

}

public typealias SimpleResource<Response> = Resource<Void, Response>
