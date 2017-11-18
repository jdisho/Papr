//
//  UnsplashAuthManager.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import Alamofire

extension URL {
    var queryPairs: [String: String] {

        var results = [String: String]()
        let pairs = self.query?.components(separatedBy: "&") ?? []
        
        for pair in pairs {
            let kv = pair.components(separatedBy: "=")
            results.updateValue(kv[1], forKey: kv[0])
        }
        
        return results
    }
}

class UnsplashAuthProvider {
    
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [String]
    
    init(clientID: String, clientSecret: String, scopes: [String] = [UnsplashScope.pub.value]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = URL(string: OAuth2Config.redirectURL.string)!
        self.scopes = scopes
    }
    
    public func accessToken(from url: URL, completion: @escaping (UnsplashAccessToken?, NSError?) -> Void) {
        let (c, e) = extractCode(from: url)
        guard let code = c else { return }
        
        if let error = e {
            completion(nil, error)
            return
        }
        
        let urlString = accessTokenURL(with: code).absoluteString
        Alamofire.request(urlString, method: .post).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                if let json = response.result.value as? [String : String] {
                    if let accessToken = json["access_token"] {
                        let token = UnsplashAccessToken(clientID: self.clientID, accessToken: accessToken)
                        completion(token, nil)
                    }
                }
            case .failure(_):
                let error = self.extractError(from: response.data!)
                completion(nil, error)
            }
        }
        
    } 
    
    // MARK: Private
    
    private func authURL() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = OAuth2Config.host.string
        components.path = "/oauth/authorize"
        
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: self.clientID),
            URLQueryItem(name: "redirect_uri", value: self.redirectURL.absoluteString),
            URLQueryItem(name: "scope", value: self.scopes.joined(separator: "+"))
        ]
        
        return components.url!
    }
    
    private func accessTokenURL(with code: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = OAuth2Config.host.string
        components.path = "/oauth/token"
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: self.clientID),
            URLQueryItem(name: "client_secret", value: self.clientSecret),
            URLQueryItem(name: "redirect_uri", value: self.redirectURL.absoluteString),
            URLQueryItem(name: "code", value: code)
        ]
        
        return components.url!
    }
    
    private func extractCode(from url: URL) -> (String?, NSError?) {
        let pairs = url.queryPairs
        if let error = pairs["error"] {
            let desc = pairs["error_description"]?.replacingOccurrences(of: "+", with: " ").removingPercentEncoding
            return (nil, UnsplashAuthError.error(with: error, description: desc))
        } else {
            guard let code = pairs["code"] else { return (nil, nil) }
            return (code, nil)
        }
    }
    
    private func extractError(from data: Data) -> NSError? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:String]
            return UnsplashAuthError.error(with: json!["error"]!, description: json!["error_description"])
        } catch {
            return nil
        }
    }
    
}
