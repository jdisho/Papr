//
//  UnsplashAuthManager.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

protocol UnsplashSessionListener {
     func didReceiveRedirect(code: String)
}

private class ListenerWrapper {
    var listener: UnsplashSessionListener?
}

class UnsplashAuthManager {
    
    var delegate: UnsplashSessionListener!
    static var sharedAuthManager: UnsplashAuthManager!
    
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [String]
    private let keychain: KeychainSwift
    
    init(clientID: String, clientSecret: String, scopes: [String] = [UnsplashScope.pub.string]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = URL(string: OAuth2Config.redirectURL.string)!
        self.scopes = scopes
        keychain = KeychainSwift()
    }
    
    public func receivedCodeRedirect(url: URL) {
        guard let code = extractCode(from: url).0 else { return }
        delegate.didReceiveRedirect(code: code)
    }
    
    public func accessToken(with code: String, completion: @escaping (UnsplashAccessToken?, NSError?) -> Void) {
        let urlString = accessTokenURL(with: code).absoluteString
        Alamofire.request(urlString, method: .post).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                if let json = response.value as? [String : Any], 
                    let accessToken = json["access_token"] as? String {
                    let token = UnsplashAccessToken(clientID: self.clientID, accessToken: accessToken)
                    self.keychain.set(token.accessToken, forKey: self.clientID)
                    completion(token, nil)
                }
            case .failure(_):
                let error = self.extractError(from: response.data!)
                completion(nil, error)
            }
        }
    } 
    
    public var authURL: URL {
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
    
    public var accessToken: String? {
        guard let token = keychain.get(self.clientID) else {
            return nil
        }
        return UnsplashAccessToken(clientID: clientID, accessToken: token).accessToken
    }
    
    public func clearAccessToken() {
        keychain.clear()
    }
    
    // MARK: Private
    
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
        if let error = url.value(for: "error"), 
            let desc = url.value(for: "error_description")?.replacingOccurrences(of: "+", with: " ").removingPercentEncoding {
            return (nil, UnsplashAuthError.error(with: error, description: desc))
        } else {
            guard let code = url.value(for: "code") else {
                return (nil, UnsplashAuthError.error(with: .invalidGrant, description: Code.invalidGrant.string))
            }
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
