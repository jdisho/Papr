//
//  AnyEncodable.swift
//  TinyNetworking
//
//  Created by Joan Disho on 31.03.18.
//

import Foundation

class AnyEncodable: Encodable {

    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encode(to: encoder)
    }
}
