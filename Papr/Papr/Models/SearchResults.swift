//
//  SearchResult.swift
//  Papr
//
//  Created by Joan Disho on 04.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct CollectionsResult: Mappable {
    
    let total: Int?
    let totalPages: Int?
    let collections: [Collection]?
    
    init(map: Mapper) {
        total = try? map.from("total")
        totalPages = try? map.from("total_pages")
        collections = try? map.from("results")
    }
}

struct PhotosResult: Mappable {
    
    let total: Int?
    let totalPages: Int?
    let photos: [Photo]?
    
    init(map: Mapper) {
        total = try? map.from("total")
        totalPages = try? map.from("total_pages")
        photos = try? map.from("results")
    }
}

struct UsersResult: Mappable {
    
    let total: Int?
    let totalPages: Int?
    let users: [User]?
    
    init(map: Mapper) {
        total = try? map.from("total")
        totalPages = try? map.from("total_pages")
        users = try? map.from("results")
    }
}

