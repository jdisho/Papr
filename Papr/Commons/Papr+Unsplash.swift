//
//  Papr+Unsplash.swift
//  Papr
//
//  Created by Joan Disho on 24.12.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation

extension Papr {
    enum Unsplash {
        static let host = "unsplash.com"
        static let callbackURLScheme = "papr://"
        static let clientID = Secrets.clientID
        static let clientSecret = Secrets.clientSecret
        static let authorizeURL = "https://unsplash.com/oauth/authorize"
        static let tokenURL = "https://unsplash.com/oauth/token"
        static let redirectURL = "papr://unsplash"
    }
}

extension Papr.Unsplash {
    enum Secrets {
        static let clientID = Secrets.environmentVariable(named: "UNSPLASH_CLIENT_ID") ?? ""
        static let clientSecret = Secrets.environmentVariable(named: "UNSPLASH_CLIENT_SECRET") ?? ""

        private static func environmentVariable(named: String) -> String? {
            guard let infoDictionary = Bundle.main.infoDictionary, let value = infoDictionary[named] as? String else {
                print("‼️ Missing Environment Variable: '\(named)'")
                return nil
            }
            return value
        }
    }
}
