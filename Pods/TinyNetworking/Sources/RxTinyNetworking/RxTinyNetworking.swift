//
//  RxTinyNetworking.swift
//  RxTinyNetworking
//
//  Created by Joan Disho on 07.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

extension TinyNetworking: ReactiveCompatible {}

public extension Reactive where Base: TinyNetworking {

    public func request<Body, Response>(
        _ resource: Resource<Body, Response>,
        session: URLSession = URLSession.shared
        ) -> Single<Response> {
        return Single.create { single in
            let task = self.base.performRequest(resource, session: session){ result in
                switch result {
                case .error(let apiError):
                    single(.error(apiError))
                case .success(let response):
                    single(.success(response))
                }
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }

}
