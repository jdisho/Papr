//
//  LikeUnlike.swift
//  Papr
//
//  Created by Joan Disho on 19.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

struct LikeUnlike {
    let photo: Photo?
    let user: User?
}

extension LikeUnlike: Decodable {
    private enum LikeUnlikeCodingKeys: String, CodingKey {
        case photo
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LikeUnlikeCodingKeys.self)
        
        photo = try? container.decode(Photo.self, forKey: .photo)
        user = try? container.decode(User.self, forKey: .user)
    }
}
