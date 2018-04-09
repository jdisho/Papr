//
//  UnsplashAuthManager.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import Moya

protocol UnsplashSessionListener {
     func didReceiveRedirect(code: String)
}

enum UnsplashAuthorization: TargetType {

    case accessToken(withCode: String)

    var baseURL: URL {
        guard let url = URL(string: "https://unsplash.com") else {
            fatalError("FAILED: https://unsplash.com")
        }
        return url
    }

    var path: String {
        return "/oauth/token"
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case let .accessToken(withCode: code):
            var params: [String: Any] = [:]

            params["grant_type"] = "authorization_code"
            params["client_id"] = UnsplashSettings.clientID.string
            params["client_secret"] = UnsplashSettings.clientSecret.string
            params["redirect_uri"] = UnsplashSettings.redirectURL.string
            params["code"] = code

            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return [:]
    }


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
    private let unplash: MoyaProvider<UnsplashAuthorization>

    // MARK: Init
    init(clientID: String, clientSecret: String, scopes: [String] = [Scope.pub.string]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = URL(string: UnsplashSettings.redirectURL.string)!
        self.scopes = scopes

        unplash = MoyaProvider<UnsplashAuthorization>()
    }

    // MARK: Public

    public func receivedCodeRedirect(url: URL) {
        guard let code = extractCode(from: url) else { return }
        delegate.didReceiveRedirect(code: code)
    }
    
    public func accessToken(with code: String, completion: @escaping (String?, Error?) -> Void) {
        unplash.request(.accessToken(withCode: code)) { response in
            DispatchQueue.main.async { [unowned self] in
                switch response {
                case let .success(result):
                    if let accessTokenObject = try? result.map(UnsplashAccessToken.self) {
                        let token = accessTokenObject.accessToken
                        UserDefaults.standard.set(token, forKey: self.clientID)
                        completion(token, nil)

                    }
                case .failure(let error):
                    switch error.response {
                    case let .some(response):
                        let errorDesc = self.extractErrorDescription(from: response.data)
                        let error = NSError(
                            domain: "com.unsplash.error",
                            code: 1,
                            userInfo: [NSLocalizedDescriptionKey: errorDesc ?? "undefined error"]
                        )
                        completion(nil, error)
                    default:
                        completion(nil, error)
                    }
                }
            }
        }
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
