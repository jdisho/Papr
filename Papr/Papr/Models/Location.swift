//
//  Location.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct Location: Mappable {
    
    let city: String?
    let country: String?
    let name: String?
    let position: String?
    let title: String?
    
    init(map: Mapper) throws {
        
        city = try? map.from("city")
        country = try? map.from("country")
        name = try? map.from("name")
        position = try? map.from("position")
        title = try? map.from("title")
    }
}
