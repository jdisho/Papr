//
//  SearchResult.swift
//  Papr
//
//  Created by Joan Disho on 04.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//


fileprivate enum ResultCodingKeys: String, CodingKey {
    case total
    case totalPages = "total_pages"
    case results
}

//MARK: CollectionsResult

struct CollectionsResult {
    let total: Int?
    let totalPages: Int?
    let collections: [Collection]?
}

extension CollectionsResult: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)

        total = try? container.decode(Int.self, forKey: .total)
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
        collections = try? container.decode([Collection].self, forKey: .results)
    }
}

//MARK: PhotosResult

struct PhotosResult {
    let total: Int?
    let totalPages: Int?
    let photos: [Photo]?
}

extension PhotosResult: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)

        total = try? container.decode(Int.self, forKey: .total)
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
        photos = try? container.decode([Photo].self, forKey: .results)
    }
}

//MARK: UsersResult

struct UsersResult {
    let total: Int?
    let totalPages: Int?
    let users: [User]?
}

extension UsersResult: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)

        total = try? container.decode(Int.self, forKey: .total)
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
        users = try? container.decode([User].self, forKey: .results)
    }
}

