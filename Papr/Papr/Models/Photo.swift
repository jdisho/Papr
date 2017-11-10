//
//  Photo.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct Photo: Mappable {
    
    let id: String?
    let created: String?
    let updated: String?
    let description: String?
    let color: String?
    let likes: Int?
    let downloads: Int?
    let views: Int?
    let width: Int?
    let height: Int?
    let user: User?
    let imageURLs: ImageURLs?
    let location: Location?
    let exif: Exif?
    
    init(map: Mapper) throws {
        
        id = try? map.from("id")
        created = try? map.from("created_at")
        updated = try? map.from("updated_at")
        description = try? map.from("description")
        color = try? map.from("color")
        likes = try? map.from("likes")
        downloads = try? map.from("downloads")
        views = try? map.from("views")
        width = try? map.from("width")
        height = try? map.from("height")
        user = try? map.from("user")
        imageURLs = try? map.from("urls")
        location = try? map.from("location")
        exif = try? map.from("exif")
    }
}


