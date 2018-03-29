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

public class TinyNetworking<Target: TargetType>: TinyNetworkingType {

    public init() {}

    @discardableResult
    public func request(
        target: Target,
        session: URLSession = URLSession.shared,
        completion: @escaping (TinyNetworkingResult<Decodable>) -> Void
        ) -> URLSessionDataTask {
        let request = URLRequest(target: target)

        let dataTask = session.dataTask(with: request) { data, response, error in
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
            do {
                guard let result = try target.resource.decode(data) else {
                    completion(.error(.decodingFailed(nil)))
                    return
                }
                completion(.success(result))
            } catch {
                completion(.error(.decodingFailed(error)))
            }
        }

        dataTask.resume()
        return dataTask
    }
}

