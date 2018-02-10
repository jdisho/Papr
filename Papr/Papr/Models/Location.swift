//
//  Location.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct Location {
    let city: String?
    let country: String?
    let name: String?
    let position: String?
    let title: String?
}

extension Location: Decodable {
    
    private enum LocationCodingKeys: String, CodingKey {
        case city
        case country
        case name
        case position
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationCodingKeys.self)
        city = try? container.decode(String.self, forKey: .city)
        country = try? container.decode(String.self, forKey: .country)
        name = try? container.decode(String.self, forKey: .name)
        position = try? container.decode(String.self, forKey: .position)
        title = try? container.decode(String.self, forKey: .title)
    }
}
