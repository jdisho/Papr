//
//  Unsplash.swift
//  Papr
//
//  Created by Joan Disho on 21.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

class Unsplash {
    
    static func config(id: String, secret: String, scopes: [String]) {
        UnsplashAuthManager.sharedAuthManager = UnsplashAuthManager(clientID: id, clientSecret: secret, scopes: scopes)
    }
    
    static func authorize(with code: String) {
        precondition(UnsplashAuthManager.sharedAuthManager != nil, "call `UnsplashAuthManager(...)` before calling this method")
        UnsplashAuthManager
            .sharedAuthManager
            .accessToken(with: code) { token, error in
                if let token = token {
                    print(token)
                } else {
                    print(error?.localizedDescription ?? "")
                }
        }
    }
    
    static var authURL: URL {
        return UnsplashAuthManager.sharedAuthManager.authURL
    }
    
}
