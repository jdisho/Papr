//
//  UnsplashAuthError.swift
//  Papr
//
//  Created by Joan Disho on 16.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

struct UnsplashAuthError {
    public static let Domain = "com.unsplash.error"
    
    static func error(with codeString: String, description: String?) -> NSError {
        var code : Code
        switch codeString {
        case "unauthorized_client": code = .unauthorizedClient
        case "access_denied": code = .accessDenied
        case "unsupported_response_type": code = .unsupportedResponseType
        case "invalid_scope": code = .invalidScope
        case "invalid_client": code = .invalidClient
        case "server_error": code = .serverError
        case "temporarily_unavailable": code = .temporarilyUnavailable
        case "invalid_request": code = .invalidRequest
        default: code = .unknown
        }
        
        return error(with: code, description: description)
    }
    
    static func error(with code: Code, description: String?) -> NSError {
        var info : [String : String]?
        if let description = description {
            info = [NSLocalizedDescriptionKey : description]
        }
        return NSError(domain: Domain, code: code.rawValue, userInfo: info) 
    }
}

public enum Code: Int {
    
    /// The client is not authorized to request an access token using this method.
    case unauthorizedClient = 1
    
    /// The resource owner or authorization server denied the request.
    case accessDenied
    
    /// The authorization server does not support obtaining an access token using this method.
    case unsupportedResponseType

    /// The authorization server encountered an unexpected condition that prevented it from
    /// fulfilling the request.
    case serverError
    
    /// The requested scope is invalid, unknown, or malformed.
    case invalidScope
    
    /// Client authentication failed due to unknown client, no client authentication included,
    /// or unsupported authentication method.
    case invalidClient
    
    /// The request is missing a required parameter, includes an unsupported parameter value, or
    /// is otherwise malformed.
    case invalidRequest
    
    /// The provided authorization grant is invalid, expired, revoked, does not match the
    /// redirection URI used in the authorization request, or was issued to another client.
    case invalidGrant
    
    /// The authorization server is currently unable to handle the request due to a temporary
    /// overloading or maintenance of the server.
    case temporarilyUnavailable
    
    /// The user canceled the authorization process.
    case userCanceledAuth
    
    /// Some other error.
    case unknown
    
    var string: String {
        switch self {
        case .unauthorizedClient:
            return "The client is not authorized to request an access token using this method."
        case .accessDenied:
            return "The resource owner or authorization server denied the request."
        case .unsupportedResponseType:
            return "The authorization server does not support obtaining an access token using this method."
        case .serverError:
            return "The authorization server encountered an unexpected condition that prevented it from fulfilling the request."
        case .invalidScope:
            return "The requested scope is invalid, unknown, or malformed."
        case .invalidClient:
            return "Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method."
        case .invalidRequest:
            return "The request is missing a required parameter, includes an unsupported parameter value, or is otherwise malformed."
        case .invalidGrant:
            return "The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client."
        case .temporarilyUnavailable:
            return "The authorization server is currently unable to handle the request due to a temporary overloading or maintenance of the server."
        case .userCanceledAuth:
            return "The user canceled the authorization process."
        case .unknown:
            return "Unknown error"
        
        }
    }
}
