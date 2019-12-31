//
//  Photo.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import RxDataSources

struct Photo: Codable {
    let id: String?
    let created: String?
    let updated: String?
    let description: String?
    let color: String?
    var likes: Int?
    var likedByUser: Bool?
    let downloads: Int?
    let views: Int?
    let width: Int?
    let height: Int?
    let user: User?
    let urls: ImageURLs?
    let location: Location?
    let exif: Exif?
    let collectionsItBelongs: [PhotoCollection]?
    let links: Links?
    let categories: [Category]?

    enum CodingKeys: String, CodingKey {
        case id
        case created = "created_at"
        case updated = "updated_at"
        case description
        case color
        case likes
        case likedByUser = "liked_by_user"
        case downloads
        case views
        case width
        case height
        case user
        case urls
        case location
        case exif
        case collectionsItBelongs = "current_user_collections"
        case links
        case categories
    }
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Photo: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
       guard let id = id else {
            fatalError("The photo id shouldn't be nil")
        }
        return id
    }
}

extension Photo: Cachable {
    var identifier: String {
        guard let id = id else {
            fatalError("The photo id shouldn't be nil")
        }
        return id
    }
}


