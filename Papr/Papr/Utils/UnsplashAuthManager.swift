//
//  UnsplashAuthManager.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Security
import Alamofire

class UnsplashAuthProvider {
    
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [String]
    
    init(clientID: String, clientSecret: String, scopes: [String] = [UnsplashScope.pub.value]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = URL(string: OAuth2Config.redirectURL.value as! String)!
        self.scopes = scopes
    }
    
    private func authURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = OAuth2Config.host.value as? String
        components.path = "/oauth/authorize"
        
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: self.clientID),
            URLQueryItem(name: "redirect_uri", value: self.redirectURL.absoluteString),
            URLQueryItem(name: "scope", value: self.scopes.joined(separator: "+"))
        ]
        
        return components.url
    }
    
    private func accessTokenURL(with code: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = OAuth2Config.host.value as? String
        components.path = "/oauth/token"
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: self.clientID),
            URLQueryItem(name: "client_secret", value: self.clientSecret),
            URLQueryItem(name: "redirect_uri", value: self.redirectURL.absoluteString),
            URLQueryItem(name: "code", value: code)
        ]
        
        return components.url
    }
}
