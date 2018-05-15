//
//  SearchResult.swift
//  Papr
//
//  Created by Joan Disho on 04.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//


//MARK: CollectionsResult

struct PhotoCollectionsResult: Decodable {
    let total: Int?
    let totalPages: Int?
    let results: [PhotoCollection]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

//MARK: PhotosResult

struct PhotosResult: Decodable {
    let total: Int?
    let totalPages: Int?
    let results: [Photo]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

//MARK: UsersResult

struct UsersResult: Decodable {
    let total: Int?
    let totalPages: Int?
    let results: [User]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

