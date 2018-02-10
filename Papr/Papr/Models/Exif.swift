//
//  Exif.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct Exif {
    let aperture: String?
    let exposureTime: String?
    let focalLength: String?
    let iso: String?
    let make: String?
    let model: String?
}

extension Exif: Decodable {
    
    private enum ExifCodingKeys: String, CodingKey {
        case aperture
        case exposureTime = "exposure_time"
        case focalLength = "focal_length"
        case iso
        case make
        case model
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExifCodingKeys.self)
        
        aperture = try? container.decode(String.self, forKey: .aperture)
        exposureTime = try? container.decode(String.self, forKey: .exposureTime)
        focalLength = try? container.decode(String.self, forKey: .focalLength)
        iso = try? container.decode(String.self, forKey: .iso)
        make = try? container.decode(String.self, forKey: .make)
        model = try? container.decode(String.self, forKey: .model) 
    }
}
