//
//  Collection.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct Collection {
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
}

extension Collection: Decodable {
    
    private enum CollectionCodingKeys: String, CodingKey {
        case id
        case coverPhoto = "cover_photo"
        case isCurated = "curated"
        case isFeatured = "featured"
        case title
        case description
        case totalPhotos = "total_photos"
        case isPrivateCollection = "private"
        case previewPhotos = "preview_photos"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case user
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CollectionCodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        coverPhoto = try? container.decode(Photo.self, forKey: .coverPhoto)
        isCurated = try? container.decode(Bool.self, forKey: .isCurated)
        isFeatured = try? container.decode(Bool.self, forKey: .isFeatured)
        title = try? container.decode(String.self, forKey: .title)
        description = try? container.decode(String.self, forKey: .description)
        totalPhotos = try? container.decode(Int.self, forKey: .totalPhotos)
        isPrivateCollection = try? container.decode(Bool.self, forKey: .isPrivateCollection)
        previewPhotos = try? container.decode([Photo].self, forKey: .previewPhotos)
        publishedAt = try? container.decode(String.self, forKey: .publishedAt)
        updatedAt = try? container.decode(String.self, forKey: .updatedAt)
        user = try? container.decode(User.self, forKey: .user)
        
    }
}
