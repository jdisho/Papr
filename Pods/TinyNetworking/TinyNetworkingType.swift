//
//  TinyNetworkingType.swift
//  TinyNetworking
//
//  Created by Joan Disho on 29.03.18.
//

import Foundation

public protocol TinyNetworkingType {

    associatedtype Target

    func request(
        target: Target,
        session: URLSession,
        completion: @escaping (TinyNetworkingResult<Decodable>) -> Void
        ) -> URLSessionDataTask
}
