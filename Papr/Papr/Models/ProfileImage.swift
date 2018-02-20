//
//  ProfileImage.swift
//  Papr
//
//  Created by Joan Disho on 03.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

struct ProfileImage {
    let small: String?
    let medium: String?
    let large: String?
}

extension ProfileImage: Decodable {

    private enum ProfileImageCodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfileImageCodingKeys.self)

        small = try? container.decode(String.self, forKey: .small)
        medium = try? container.decode(String.self, forKey: .medium)
        large = try? container.decode(String.self, forKey: .large)
    }
}
