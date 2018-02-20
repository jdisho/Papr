//
//  Photo.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import RxDataSources

struct Photo {
    let id: String?
    let created: String?
    let updated: String?
    let description: String?
    let color: String?
    let likes: Int?
    let likedByUser: Bool?
    let downloads: Int?
    let views: Int?
    let width: Int?
    let height: Int?
    let user: User?
    let urls: ImageURLs?
    let location: Location?
    let exif: Exif?
    let collectionsItBelongs: [Collection]?
    let links: Links?
    let categories: [Category]?
}

extension Photo: Decodable {
    
    private enum PhotoCodingKeys: String, CodingKey {
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotoCodingKeys.self)

        id = try? container.decode(String.self, forKey: .id)
        created = try? container.decode(String.self, forKey: .created)
        updated = try? container.decode(String.self, forKey: .updated)
        description = try? container.decode(String.self, forKey: .description)
        color = try? container.decode(String.self, forKey: .color)
        likes = try? container.decode(Int.self, forKey: .likes)
        likedByUser = try? container.decode(Bool.self, forKey: .likedByUser)
        downloads = try? container.decode(Int.self, forKey: .downloads)
        views = try? container.decode(Int.self, forKey: .views)
        width = try? container.decode(Int.self, forKey: .width)
        height = try? container.decode(Int.self, forKey: .height)
        user = try? container.decode(User.self, forKey: .user)
        urls = try? container.decode(ImageURLs.self, forKey: .urls)
        location = try? container.decode(Location.self, forKey: .location)
        exif = try? container.decode(Exif.self, forKey: .exif)
        collectionsItBelongs = try? container.decode([Collection].self, forKey: .collectionsItBelongs)
        links = try? container.decode(Links.self, forKey: .links)
        categories = try? container.decode([Category].self, forKey: .categories)
    }

}

extension Photo: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
        guard id != nil else { return "" }
        return id!
    }
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id && 
                lhs.created == rhs.created && 
                lhs.user?.id == rhs.user?.id
    }
}


