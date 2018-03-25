//
//  UnsplashAuthError.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

struct UnsplashAuthError: Decodable {

    let error: String
    let errorDescription: String

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
