//
//  HttpMethod.swift
//  TinyNetworking
//
//  Created by Joan Disho on 02.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public enum HttpMethod<Body> {
    case get
    case post(Body)
    case delete
    case put(Body)
}

extension HttpMethod {
    var value: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }

}

extension HttpMethod {
    func map<T>(_ transform: (Body) -> T) -> HttpMethod<T> {
        switch self {
        case .get:
            return .get
        case let .post(body):
            return .post(transform(body))
        case .delete:
            return .delete
        case let .put(body):
            return .put(transform(body))
        }
    }

}

