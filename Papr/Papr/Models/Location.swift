//
//  Location.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

// MARK: Possition

struct Possition: Decodable {
    let latitude: Double?
    let longitude: Double?

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

// MARK: Location

struct Location: Decodable {
    let city: String?
    let country: String?
    let position: Possition?

    enum CodingKeys: String, CodingKey {
        case city
        case country
        case position
    }
}
