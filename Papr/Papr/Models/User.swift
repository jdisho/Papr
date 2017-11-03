//
//  User.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper

struct User: Mappable {
    
    let id: String?
    let username: String?
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let email: String?
    let bio: String?
    let location: String?
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
    
    init(map: Mapper) throws {
    
        id = try? map.from("id")
        username = try? map.from("username")
        firstName = try? map.from("first_name")
        lastName = try? map.from("last_name")
        fullName = try? map.from("name")
        email = try? map.from("email")
        bio = try? map.from("bio")
        location = try? map.from("location")
        portfolioURL = try? map.from("portfolio_url")
        profileImage = try? map.from("profile_image")
        followersCount = try? map.from("followers_count")
        photos = try? map.from("photos")
        followingCount = try? map.from("following_count")
        totalLikes = try? map.from("total_likes")
        totalPhotos = try? map.from("total_photos")
        totalCollections = try? map.from("total_collections")
        uploadsRemaining = try? map.from("uploads_remaining")
        downloads = try? map.from("downloads")
    }

}
