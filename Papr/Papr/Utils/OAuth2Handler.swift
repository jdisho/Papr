//
//  OAuth2Handler.swift
//  Papr
//
//  Created by Joan Disho on 01.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire


class OAuth2Handler {
    
    fileprivate let loader: OAuth2DataLoader
    
    init(oauth2: OAuth2) {
        loader = OAuth2DataLoader(oauth2: oauth2)
    }

}

/** 
 The RequestRetrier protocol allows a Request 
 that encountered an Error while being executed to be retried.
*/

extension OAuth2Handler: RequestRetrier {
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, let req = request.request {
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize() { authParams, error in
                self.loader.dequeueAndApply() { req in
                    if let comp = req.context as? RequestRetryCompletion {
                        comp(authParams != nil, 0.0)
                    }
                }
            }
        }
        else {
            completion(false, 0.0)  
        }
    }
    
}


/** 
 The RequestAdapter protocol allows each Request made on a SessionManager
 to be inspected and adapted before being created.
*/

extension OAuth2Handler: RequestAdapter {
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard loader.oauth2.accessToken != nil else {
            return urlRequest
        }
        return try urlRequest.signed(with: loader.oauth2) 
    }
    
}
