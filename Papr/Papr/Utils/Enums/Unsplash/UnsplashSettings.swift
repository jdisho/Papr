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
            return UnsplashSecrets.clientID
        case .clientSecret:
            return UnsplashSecrets.clientSecret
        case .authorizeURL:
            return "https://unsplash.com/oauth/authorize"
        case .tokenURL:
            return "https://unsplash.com/oauth/token"
        case .redirectURL:
            return "papr://unsplash"
        }
    }

    enum UnsplashSecrets {

        static let clientID = UnsplashSecrets.environmentVariable(named: "UNSPLASH_CLIENT_ID") ?? ""
        static let clientSecret = UnsplashSecrets.environmentVariable(named: "UNSPLASH_CLIENT_SECRET") ?? ""

        static func environmentVariable(named: String) -> String? {
            let processInfo = ProcessInfo.processInfo
            guard let value = processInfo.environment[named] else {
                print("‼️ Missing Environment Variable: '\(named)'")
                return nil
            }
            return value

        }
    }
}
