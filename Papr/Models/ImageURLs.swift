//
//  ImageURLs.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct ImageURLs: Codable {
    let full: String?
    let raw: String?
    let regular: String?
    let small: String?
    let thumb: String?

    enum CodingKeys: String, CodingKey {
        case full
        case raw
        case regular
        case small
        case thumb
    }
}

