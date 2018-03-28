//
//  URLRequest+Extentions.swift
//  TinyNetworking
//
//  Created by Joan Disho on 02.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public extension URLRequest {

    init(target: TargetType) {
        let url = target.baseURL.appendingPathComponent(target.endpoint)
        let parameters = target.parameters

        self.init(url: url.appendingQueryParameters(parameters))

        httpMethod = target.resource.method.value

        for (key, value) in target.headers {
            addValue(value, forHTTPHeaderField: key)
        }

        if case let .post(data) = target.resource.method {
            httpBody = data
        }
    }

}
