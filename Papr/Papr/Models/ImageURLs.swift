//
//  ImageURLs.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct ImageURLs: Mappable {

    let full: String?
    let raw: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
    init(map: Mapper) throws {
        
        full = try? map.from("full")
        raw = try? map.from("raw")
        regular = try? map.from("regular")
        small = try? map.from("small")
        thumb = try? map.from("thumb")
    }
}
