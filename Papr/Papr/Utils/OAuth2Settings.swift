//
//  OAuth2Settings.swift
//  Papr
//
//  Created by Joan Disho on 02.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import p2_OAuth2

enum OAuth2Config {
    case clientID
    case clientSecret
    case authorizeURL
    case tokenURL
    case scope
    case redirectURL
    case secretInBody
    case verbose
    case keychain
    case settings
    
    var value: Any {
        switch self {
        case .clientID:
            return "0dd1dc721b7672e96f4bdf71af623fb68ea7b1d4829681744a4a08e0a8ef68c8"
        case .clientSecret:
            return "550dfea297d53e54b05f0a59458a3bddce6217f8f44e34d30524a3b0d2425eca"
        case .authorizeURL:
            return "https://unsplash.com/oauth/authorize"
        case .tokenURL:
            return "https://unsplash.com/oauth/token"
        case .scope:
            return UnsplashScope.fullScope.value
        case .redirectURL:
            return "paprapp://oauth/callback"
        case .secretInBody:
            return true
        case .verbose:
            return false
        case .keychain:
            return false
        case .settings:
            return [
                "client_id": OAuth2Config.clientID.value,
                "client_secret": OAuth2Config.clientSecret.value,
                "authorize_uri": OAuth2Config.authorizeURL.value,
                "token_uri": OAuth2Config.tokenURL.value,
                "scope": OAuth2Config.scope.value,
                "redirect_uris": [OAuth2Config.redirectURL.value],
                "secret_in_body": OAuth2Config.secretInBody.value,
                "verbose": OAuth2Config.verbose.value,
                "keychain": OAuth2Config.keychain.value
            ]
        }
    }
}
