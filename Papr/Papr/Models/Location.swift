//
//  Location.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

// MARK: Possition

struct Possition {
    let latitude: Double?
    let longitude: Double?
}

extension Possition: Decodable {
    
    private enum PossitionCodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PossitionCodingKeys.self)

        latitude = try? container.decode(Double.self, forKey: .latitude)
        longitude = try? container.decode(Double.self, forKey: .longitude)
    }
}


// MARK: Location

struct Location {
    let city: String?
    let country: String?
    let position: Possition?
}

extension Location: Decodable {
    
    private enum LocationCodingKeys: String, CodingKey {
        case city
        case country
        case position
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationCodingKeys.self)

        city = try? container.decode(String.self, forKey: .city)
        country = try? container.decode(String.self, forKey: .country)
        position = try? container.decode(Possition.self, forKey: .position)
    }
}
