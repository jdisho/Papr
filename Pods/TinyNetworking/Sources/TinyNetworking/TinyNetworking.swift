//
//  TinyNetworking.swift
//  TinyNetworking
//
//  Created by Joan Disho on 02.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public enum NetworkResult<T> {
    case success(T)
    case error(NetworkError)
}

public enum NetworkError: Error {
    case error(Error?)
    case emptyResult
    case decodingFailed(Error?)
    case noHttpResponse
    case requestFailed(with: URLResponse)
}

public class TinyNetworking {

    public init() {}

    @discardableResult
    func performRequest<Body, Response>(
        _ resource: Resource<Body, Response>,
        session: URLSession = URLSession.shared,
        completion: @escaping (NetworkResult<Response>) -> Void
        ) -> URLSessionDataTask {
        let request = URLRequest(resource: resource)
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.error(NetworkError.error(error)))
                return
            }
            guard let data = data else {
                completion(.error(NetworkError.emptyResult))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.error(NetworkError.noHttpResponse))
                return
            }
            guard 200..<300 ~= response.statusCode else {
                completion(.error(NetworkError.requestFailed(with: response)))
                return
            }
            do {
                guard let result = try resource.decode(data) else {
                    completion(.error(NetworkError.decodingFailed(nil)))
                    return
                }

                completion(.success(result))
            } catch {
                completion(.error(NetworkError.decodingFailed(error)))
            }
        }

        dataTask.resume()
        return dataTask
    }

    public func request<Body, Response>(
        _ resource: Resource<Body, Response>,
        session: URLSession = URLSession.shared,
        completion: @escaping (NetworkResult<Response>) -> Void
        ) {
        performRequest(resource, session: session, completion: completion)
    }

}
