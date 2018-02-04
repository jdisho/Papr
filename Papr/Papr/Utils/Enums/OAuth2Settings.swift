//
//  OAuth2Settings.swift
//  Papr
//
//  Created by Joan Disho on 02.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

enum OAuth2Config {
    case host
    case callbackURLScheme
    case clientID
    case clientSecret
    case authorizeURL
    case tokenURL
    case redirectURL
    
    var string: String {
        switch self {
        case .host:
            return "unsplash.com"
        case .callbackURLScheme:
            return "papr://"
        case .clientID:
            return "8e6b2ead64a72c5b4e549058959af5924c6ad3140888a6fd24ada746d047212a"
        case .clientSecret:
            return "2e8d1495c35a3be19235ae97747b83073f368c45c401476fc86e94d316283d87"
        case .authorizeURL:
            return "https://unsplash.com/oauth/authorize"
        case .tokenURL:
            return "https://unsplash.com/oauth/token"
        case .redirectURL:
            return "papr://unsplash"
        }
    }
}
