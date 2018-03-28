//
//  UnsplashAuthManager.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import TinyNetworking

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

    // MARK: Private
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [String]

    // MARK: Init
    init(clientID: String, clientSecret: String, scopes: [String] = [Scope.pub.string]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = URL(string: UnsplashSettings.redirectURL.string)!
        self.scopes = scopes
    }

    // MARK: Public

    public func receivedCodeRedirect(url: URL) {
        guard let code = extractCode(from: url) else { return }
        delegate.didReceiveRedirect(code: code)
    }
    
    public func accessToken(with code: String, completion: @escaping (String?, Error?) -> Void) {
//        let resource = Resource<String, UnsplashAccessToken>(
//            url: accessTokenURL(with: code),
//            method: .post(code))
//
//        Unsplash().request(resource) { response in
//            DispatchQueue.main.async { [unowned self] in
//                switch response {
//                case let .success(result):
//                    UserDefaults.standard.set(result.accessToken, forKey: self.clientID)
//                    completion(result.accessToken, nil)
//                case let .error(error):
//                    switch error {
//                    case let .requestFailed(data):
//                        let errorDesc = self.extractErrorDescription(from: data)
//                        let error = NSError(
//                            domain: "com.unsplash.error",
//                            code: 1,
//                            userInfo: [NSLocalizedDescriptionKey: errorDesc ?? "undefined error"]
//                        )
//                        completion(nil, error)
//                    default:
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
    } 
    
    public var authURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = UnsplashSettings.host.string
        components.path = "/oauth/authorize"


        var params: [String: String] = [:]
        params["response_type"] = "code"
        params["client_id"] = clientID
        params["redirect_uri"] = redirectURL.absoluteString
        params["scope"] = scopes.joined(separator: "+")

        let url = components.url?.appendingQueryParameters(params)

        return url!
    }
    
    public var accessToken: String? {
        guard let token = UserDefaults.standard.string(forKey: clientID) else {
            return nil
        }
        return token
    }
    
    public func clearAccessToken() {
        UserDefaults.standard.removeObject(forKey: clientID)
    }
    
    // MARK: Private
    
    private func accessTokenURL(with code: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = UnsplashSettings.host.string
        components.path = "/oauth/token"

        var params: [String: String] = [:]
        params["grant_type"] = "authorization_code"
        params["client_id"] = clientID
        params["client_secret"] = clientSecret
        params["redirect_uri"] = redirectURL.absoluteString
        params["code"] = code

        let url = components.url?.appendingQueryParameters(params)
        
        return url!
    }
    
    private func extractCode(from url: URL) -> String? {
        guard let code = url.value(for: "code") else { return nil }
        return code
    }
    
    private func extractErrorDescription(from data: Data) -> String? {
        let error = try? JSONDecoder().decode(UnsplashAuthError.self, from: data)
        guard let authError = error else { return nil }
        return authError.errorDescription
    }
}
