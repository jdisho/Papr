//
//  ProfileImage.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct ProfileImage: Mappable {
    
    let small: String
    let medium: String
    let large: String
    
    init(map: Mapper) throws {
        
        small = try! map.from("small")
        medium = try! map.from("medium")
        large = try! map.from("large")
    }
    
}
