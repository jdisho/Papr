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

enum UnsplashAuthorization: ResourceType {

    case accessToken(withCode: String)

    var baseURL: URL {
        guard let url = URL(string: "https://unsplash.com") else {
            fatalError("FAILED: https://unsplash.com")
        }
        return url
    }

    var endpoint: Endpoint {
        return .post(path: "/oauth/token")
    }

    var task: Task {
        switch self {
        case let .accessToken(withCode: code):
            var params: [String: Any] = [:]

            params["grant_type"] = "authorization_code"
            params["client_id"] = Constants.UnsplashSettings.clientID
            params["client_secret"] = Constants.UnsplashSettings.clientSecret
            params["redirect_uri"] = Constants.UnsplashSettings.redirectURL
            params["code"] = code

            return .requestWithParameters(params, encoding: URLEncoding())
        }
    }

    var headers: [String : String] {
        return [:]
    }
}

class UnsplashAuthManager {

    var delegate: UnsplashSessionListener!

    static var shared: UnsplashAuthManager {
        return UnsplashAuthManager(
            clientID: Constants.UnsplashSettings.clientID,
            clientSecret: Constants.UnsplashSettings.clientSecret, 
            scopes: Scope.allCases
        )
    }

    // MARK: Private Properties
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [Scope]
    private let unplash: TinyNetworking<UnsplashAuthorization>

    // MARK: Public Properties
    public var accessToken: String? {
        return UserDefaults.standard.string(forKey: clientID)
    }

    public func clearAccessToken() {
        UserDefaults.standard.removeObject(forKey: clientID)
    }

    public var authURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.UnsplashSettings.host
        components.path = "/oauth/authorize"

        var params: [String: String] = [:]
        params["response_type"] = "code"
        params["client_id"] = clientID
        params["redirect_uri"] = redirectURL.absoluteString
        params["scope"] = scopes.map { $0.rawValue }.joined(separator: "+")

        let url = components.url?.appendingQueryParameters(params)

        return url!
    }

    // MARK: Init
    init(clientID: String,
         clientSecret: String,
         scopes: [Scope] = [Scope.pub],
         unsplash:  TinyNetworking<UnsplashAuthorization> = TinyNetworking<UnsplashAuthorization>()) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = URL(string: Constants.UnsplashSettings.redirectURL)!
        self.scopes = scopes
        self.unplash = unsplash
    }

    // MARK: Public
    public func receivedCodeRedirect(url: URL) {
        guard let code = extractCode(from: url) else { return }
        delegate.didReceiveRedirect(code: code)
    }
    
    public func accessToken(with code: String, completion: @escaping (String?, Error?) -> Void) {
        unplash.request(resource: .accessToken(withCode: code)) { [unowned self] response in
            switch response {
            case let .success(result):
                if let accessTokenObject = try? result.map(to: UnsplashAccessToken.self) {
                    let token = accessTokenObject.accessToken
                    UserDefaults.standard.set(token, forKey: self.clientID)
                    completion(token, nil)
                }
            case let .error(error):
                completion(nil, error)
            }
        }
    }

    // MARK: Private
    private func accessTokenURL(with code: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.UnsplashSettings.host
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
       return url.value(for: "code")
    }
    
    private func extractErrorDescription(from data: Data) -> String? {
        let error = try? JSONDecoder().decode(UnsplashAuthError.self, from: data)
        return error?.errorDescription
    }
}
