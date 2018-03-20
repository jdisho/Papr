//
//  LikeUnlike.swift
//  Papr
//
//  Created by Joan Disho on 19.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

struct LikeUnlike: Decodable {
    let photo: Photo?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case photo
        case user
    }
}
