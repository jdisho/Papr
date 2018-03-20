//
//  Unsplash.swift
//  Papr
//
//  Created by Joan Disho on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import TinyNetworking
import RxSwift
class Unsplash {

    // MARK: Private
    private let tinyNetworking: TinyNetworking
    private let token: String?

    // MARK: Init
    init(tinyNetworking: TinyNetworking = TinyNetworking()) {
        self.tinyNetworking = tinyNetworking
        token = UserDefaults.standard
                .string(forKey: UnsplashSettings.clientID.string)
    }

    func request<Body, Response>(
        _ resource: Resource<Body, Response>,
        completion: @escaping (NetworkResult<Response>)-> Void
        ) {
        guard let token = token else {
            let resource = resource.addHeader(
                key: "Authorization",
                value: "Client-ID " + UnsplashSettings.clientID.string)

            tinyNetworking.request(resource, completion: completion)
            return
        }

        let authorizedResource = resource.addHeader(
            key: "Authorization",
            value: "Bearer " + token)

        tinyNetworking.request(authorizedResource, completion: completion)
        return
    }

    // MARK: RxSwift
    func request<Body, Response>(
        _ resource: Resource<Body, Response>
        ) -> Single<Response> {
        guard let token = token else {
            let resource = resource.addHeader(
                key: "Authorization",
                value: "Client-ID " + UnsplashSettings.clientID.string)

            return tinyNetworking.rx
                .request(resource)
                .observeOn(MainScheduler.instance)
        }

        let authorizedResource = resource.addHeader(
            key: "Authorization",
            value: "Bearer " + token)

        return tinyNetworking.rx
            .request(authorizedResource)
            .observeOn(MainScheduler.instance)
    }
}

