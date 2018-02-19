//
//  User.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct User {
    let id: String?
    let username: String?
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let email: String?
    let bio: String?
    let location: String?
    let followedByUser: Bool?
    let portfolioURL: String?
    let profileImage: ProfileImage?
    let followersCount: Int?
    let followingCount: Int?
    let photos: [Photo]?
    let totalLikes: Int?
    let totalPhotos: Int?
    let totalCollections: Int?
    let uploadsRemaining: Int?
    let downloads: Int?
    let links: Links?
}  

extension User: Decodable {
    
    enum UserCodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case fullName = "name"
        case email
        case bio
        case location
        case followedByUser = "followed_by_user"
        case portfolioURL = "portfolio_url"
        case profileImage = "profile_image"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case photos
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case uploadsRemaining = "uploads_remaining"
        case downloads
        case links
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)

        id = try? container.decode(String.self, forKey: .id)
        username = try? container.decode(String.self, forKey: .username)
        firstName = try? container.decode(String.self, forKey: .firstName)
        lastName = try? container.decode(String.self, forKey: .lastName)
        fullName = try? container.decode(String.self, forKey: .fullName)
        email = try? container.decode(String.self, forKey: .email)
        bio = try? container.decode(String.self, forKey: .bio)
        location = try? container.decode(String.self, forKey: .location)
        followedByUser = try? container.decode(Bool.self, forKey: .followedByUser)
        portfolioURL = try? container.decode(String.self, forKey: .portfolioURL)
        profileImage = try? container.decode(ProfileImage.self, forKey: .profileImage)
        followersCount = try? container.decode(Int.self, forKey: .followersCount)
        followingCount = try? container.decode(Int.self, forKey: .followingCount)
        photos = try? container.decode([Photo].self, forKey: .photos)
        totalLikes = try? container.decode(Int.self, forKey: .totalLikes)
        totalPhotos = try? container.decode(Int.self, forKey: .totalPhotos)
        totalCollections = try? container.decode(Int.self, forKey: .totalCollections)
        uploadsRemaining = try? container.decode(Int.self, forKey: .uploadsRemaining)
        downloads = try? container.decode(Int.self, forKey: .downloads)
        links = try? container.decode(Links.self, forKey: .links)
    }
}

