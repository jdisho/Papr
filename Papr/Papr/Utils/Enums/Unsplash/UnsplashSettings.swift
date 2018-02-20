//
//  UnsplashSettings.swift
//  Papr
//
//  Created by Joan Disho on 02.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

enum UnsplashSettings {
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
            return "0dd1dc721b7672e96f4bdf71af623fb68ea7b1d4829681744a4a08e0a8ef68c8"
        case .clientSecret:
            return "550dfea297d53e54b05f0a59458a3bddce6217f8f44e34d30524a3b0d2425eca"
        case .authorizeURL:
            return "https://unsplash.com/oauth/authorize"
        case .tokenURL:
            return "https://unsplash.com/oauth/token"
        case .redirectURL:
            return "papr://unsplash"
        }
    }
}
