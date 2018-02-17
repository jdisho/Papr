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

class UnsplashAuthManager {

    var delegate: UnsplashSessionListener!

    static var sharedAuthManager: UnsplashAuthManager {
        return UnsplashAuthManager(
            clientID: UnsplashSettings.clientID.string, 
            clientSecret: UnsplashSettings.clientSecret.string, 
            scopes: [Scope.pub.string,
                     Scope.readUser.string,
                     Scope.writeUser.string,
                     Scope.readPhotos.string,
                     Scope.writePhotos.string,
                     Scope.writeLikes.string,
                     Scope.writeFollowers.string,
                     Scope.readCollections.string,
                     Scope.writeCollections.string 
            ])
    }
    
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [String]
    private let keychain: KeychainSwift
    
    init(clientID: String, clientSecret: String, scopes: [String] = [Scope.pub.string]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = URL(string: UnsplashSettings.redirectURL.string)!
        self.scopes = scopes
        keychain = KeychainSwift()
    }
    
    public func receivedCodeRedirect(url: URL) {
        guard let code = extractCode(from: url).code else { return }
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
        components.host = UnsplashSettings.host.string
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
        components.host = UnsplashSettings.host.string
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
    
    private func extractCode(from url: URL) -> (code: String?, error: NSError?) {
        if let error = url.value(for: "error"), 
            let desc = url.value(for: "error_description")?.replacingOccurrences(of: "+", with: " ").removingPercentEncoding {
            return (code: nil, error: UnsplashAuthError.error(with: error, description: desc))
        } else {
            guard let code = url.value(for: "code") else {
                return (code: nil, error: UnsplashAuthError.error(with: .invalidGrant, description: Code.invalidGrant.string))
            }
            return (code: code, error: nil)
        }
    }
    
    private func extractError(from data: Data) -> NSError? {
        let anyJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let stringJSON = anyJSON as? [String:String]
        guard let json = stringJSON, 
            let error = json["error"], 
            let errorDescription = json["error_description"] 
            else { return nil }

        return UnsplashAuthError.error(with: error, description: errorDescription)
    }
    
}
