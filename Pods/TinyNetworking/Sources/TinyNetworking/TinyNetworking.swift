//
//  TinyNetworking.swift
//  TinyNetworking
//
//  Created by Joan Disho on 02.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public enum TinyNetworkingResult<T> {
    case success(T)
    case error(TinyNetworkingError)
}

public enum TinyNetworkingError: Error {
    case error(Error?)
    case emptyResult
    case decodingFailed(Error?)
    case noHttpResponse
    case requestFailed(Data)
}


public class TinyNetworking<Resource: ResourceType>: TinyNetworkingType {

    public init() {}

    @discardableResult
    public func request(
        resource: Resource,
        session: TinyNetworkingSession = URLSession.shared,
        completion: @escaping (TinyNetworkingResult<Response>) -> Void
        ) -> URLSessionDataTask {
        let request = URLRequest(resource: resource)
        return session.loadData(with: request) { data, response, error in
            guard error == nil else {
                completion(.error(.error(error)))
                return
            }
            guard let data = data else {
                completion(.error(.emptyResult))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.error(.noHttpResponse))
                return
            }
            guard 200..<300 ~= response.statusCode else {
                completion(.error(.requestFailed(data)))
                return
            }

            completion(.success(Response(urlRequest: request, data: data)))
        }
    }

}

