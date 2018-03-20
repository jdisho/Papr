//
//  Exif.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct Exif: Codable {
    let aperture: String?
    let exposureTime: String?
    let focalLength: String?
    let iso: Int?
    let make: String?
    let model: String?

    enum CodingKeys: String, CodingKey {
        case aperture
        case exposureTime = "exposure_time"
        case focalLength = "focal_length"
        case iso
        case make
        case model
    }
}
