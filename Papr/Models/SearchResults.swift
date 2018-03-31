//
//  SearchResult.swift
//  Papr
//
//  Created by Joan Disho on 04.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//


//MARK: CollectionsResult

struct CollectionsResult: Decodable {
    let total: Int?
    let totalPages: Int?
    let collections: [Collection]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case collections
    }
}

//MARK: PhotosResult

struct PhotosResult: Decodable {
    let total: Int?
    let totalPages: Int?
    let photos: [Photo]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case photos
    }
}

//MARK: UsersResult

struct UsersResult: Decodable {
    let total: Int?
    let totalPages: Int?
    let users: [User]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case users
    }
}

