//
//  Collection.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct Collection: Mappable {
    
    let id: Int?
    let coverPhoto: Photo?
    let isCurated: Bool?
    let isFeatured: Bool?
    let title: String?
    let description: String?
    let totalPhotos: Int?
    let isPrivateCollection: Bool?
    let previewPhotos: [Photo]?
    let publishedAt: String?
    let updatedAt: String?
    let user: User?
    
    init(map: Mapper) throws {

        id = try? map.from("id")
        coverPhoto = try? map.from("cover_photo")
        isCurated = try? Bool(map.from("curated"))
        isFeatured = try? Bool(map.from("featured"))
        title = try? map.from("title")
        description = try? map.from("description")
        totalPhotos = try? map.from("total_photos")
        isPrivateCollection = try? Bool(map.from("private"))
        previewPhotos = try? map.from("preview_photos")
        publishedAt = try? map.from("published_at")
        updatedAt = try? map.from("updated_at")
        user = try? map.from("user")
    }

}
