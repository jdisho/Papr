//
//  Constants+Unsplash.swift
//  Papr
//
//  Created by Joan Disho on 03.10.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation

extension Constants {
    enum Unsplash {
        enum Settings {
            static let host = "unsplash.com"
            static let callbackURLScheme = "papr://"
            static let clientID = Unsplash.Secrets.clientID
            static let clientSecret = Unsplash.Secrets.clientSecret
            static let authorizeURL = "https://unsplash.com/oauth/authorize"
            static let tokenURL = "https://unsplash.com/oauth/token"
            static let redirectURL = "papr://unsplash"
        }

        enum Secrets {
            static let clientID = environmentVariable(named: "UNSPLASH_CLIENT_ID") ?? ""
            static let clientSecret = environmentVariable(named: "UNSPLASH_CLIENT_SECRET") ?? ""

            private static func environmentVariable(named: String) -> String? {
                guard let infoDictionary = Bundle.main.infoDictionary, let value = infoDictionary[named] as? String else {
                    print("‼️ Missing Environment Variable: '\(named)'")
                    return nil
                }
                return value
            }
        }
    }
}
