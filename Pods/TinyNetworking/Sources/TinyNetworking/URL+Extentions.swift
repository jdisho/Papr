//
//  URL+Extentions.swift
//  TinyNetworking
//
//  Created by Joan Disho on 13.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public extension URL {
    
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = urlComponents.queryItems ?? []

        queryItems += parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }

}
