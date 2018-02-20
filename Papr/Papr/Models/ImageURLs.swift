//
//  ImageURLs.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct ImageURLs {
    let full: String?
    let raw: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

extension ImageURLs: Decodable {
    
    private enum URLCodingKeys: String, CodingKey {
        case full
        case raw
        case regular
        case small
        case thumb
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: URLCodingKeys.self)

        full = try? container.decode(String.self, forKey: .full)
        raw = try? container.decode(String.self, forKey: .raw)
        regular = try? container.decode(String.self, forKey: .regular)
        small = try? container.decode(String.self, forKey: .small)
        thumb = try? container.decode(String.self, forKey: .thumb)
    }
}

