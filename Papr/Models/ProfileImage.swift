//
//  ProfileImage.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?

    enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}
