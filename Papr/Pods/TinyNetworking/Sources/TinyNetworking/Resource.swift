//
//  Resource.swift
//  TinyNetworking
//
//  Created by Joan Disho on 02.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public struct Resource<Body, Response> {
    let url: URL
    let method: HttpMethod<Data?>
    let decode: (Data) throws -> Response?
    let parameters: [String: String]
    let headers: [String: String]

    public func addHeader(
        key: String,
        value: String
        ) -> Resource<Body, Response> {
        var headers = self.headers
        headers[key] = value
        return Resource<Body, Response>(
            url: url,
            method: method,
            decode: decode,
            parameters: parameters,
            headers: headers
        )
    }

}

public extension Resource where Body: Encodable,
                                Response: Decodable {
    init(
        url: URL,
        method: HttpMethod<Body> = .get,
        parameters: [String: String] = [:],
        headers: [String: String] = [:]
        ) {
        self.url = url
        self.method =  method.map { try? JSONEncoder().encode($0) }
        self.decode = { try JSONDecoder().decode(Response.self,from: $0) }
        self.parameters = parameters
        self.headers = headers
    }

}

public extension Resource where Body == Void,
                                Response: Decodable {
    init(
        url: URL,
        method: HttpMethod<Body> = .get,
        parameters: [String: String] = [:],
        headers: [String: String] = [:]
        ) {
        self.url = url
        self.method =  method.map { _ in return nil }
        self.decode = { try JSONDecoder().decode(Response.self, from: $0) }
        self.parameters = parameters
        self.headers = headers
    }

}

public typealias SimpleResource<Response> = Resource<Void, Response>
