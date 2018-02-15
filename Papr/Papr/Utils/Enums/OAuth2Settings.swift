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
            return "efad01f860e1c642aa52470892d2901a74d11bfc0301eef7f37b182bb8118898"
        case .clientSecret:
            return "1ec7feb0521a5237a30ca5fb6eef7bad1d50526d45ad45178c4a769dabd048d8"
        case .authorizeURL:
            return "https://unsplash.com/oauth/authorize"
        case .tokenURL:
            return "https://unsplash.com/oauth/token"
        case .redirectURL:
            return "papr://unsplash"
        }
    }
}
