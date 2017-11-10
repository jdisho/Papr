//
//  Exif.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct Exif: Mappable {
    
    let aperture: String?
    let exposureTime: String?
    let focalLength: String?
    let iso: String?
    let make: String?
    let model: String?
    
    init(map: Mapper) throws {
        
        aperture = try? map.from("aperture")
        exposureTime = try? map.from("exposure_time")
        focalLength = try? map.from("focal_length")
        iso = try? map.from("iso")
        make = try? map.from("make")
        model = try? map.from("model")
    }
}
