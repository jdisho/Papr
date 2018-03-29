//
//  PhotoStatistics.swift
//  Papr
//
//  Created by Joan Disho on 05.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

struct Stats: Decodable {
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case total
    }
}

struct PhotoStatistics: Decodable {
    let id: String?
    let downloads: Stats?
    let views: Stats?
    let likes: Stats?

    enum CodingKeys: String, CodingKey {
        case id
        case downloads
        case views
        case likes
    }
}

struct UserStatistics: Decodable {
    let username: String?
    let downloads: Stats?
    let views: Stats?
    let likes: Stats?

    enum CodingKeys: String, CodingKey {
        case username
        case downloads
        case views
        case likes
    }
}
