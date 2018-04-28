//
//  PhotoCollection.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import RxDataSources

struct PhotoCollection: Codable {
    let id: Int?
    let coverPhoto: Photo?
    let isCurated: Bool?
    let isFeatured: Bool?
    let title: String?
    let description: String?
    let totalPhotos: Int?
    let isPrivate: Bool?
    let publishedAt: String?
    let updatedAt: String?
    let user: User?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id
        case coverPhoto = "cover_photo"
        case isCurated = "curated"
        case isFeatured = "featured"
        case title
        case description
        case totalPhotos = "total_photos"
        case isPrivate = "private"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case user
        case links
    }
}

extension PhotoCollection: IdentifiableType {
    typealias Identity = Int

    var identity: Identity {
        guard id != nil else { return -999 }
        return id!
    }
}

struct CollectionResponse: Decodable {
    let photo: Photo?
    let collection: PhotoCollection?
    let user: User?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case photo
        case collection
        case user
        case createdAt = "created_at"
    }
}

