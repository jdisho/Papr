//
//  TinyNetworkingType.swift
//  TinyNetworking
//
//  Created by Joan Disho on 29.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public protocol TinyNetworkingType {

    associatedtype Resource

    func request(
        resource: Resource,
        session: URLSession,
        completion: @escaping (TinyNetworkingResult<Response>) -> Void
        ) -> URLSessionDataTask
}
