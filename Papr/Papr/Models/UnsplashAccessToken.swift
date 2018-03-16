//
//  UnsplashAccessToken.swift
//  Papr
//
//  Created by Joan Disho on 17.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

struct UnsplashAccessToken: Decodable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
    }
}
