//
//  RxTinyNetworking.swift
//  RxTinyNetworking
//
//  Created by Joan Disho on 07.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

extension TinyNetworking: ReactiveCompatible {}

public extension Reactive where Base: TinyNetworkingType {
    func request(
        resource: Base.Resource,
        session: URLSession = URLSession.shared
        ) -> Single<Response> {
        return Single.create { single in
            let task = self.base.request(resource: resource, session: session) { result in
                switch result {
                case let .error(apiError):
                    single(.error(apiError))
                case let .success(response):
                    single(.success(Response(
                        urlRequest: response.urlRequest,
                        data: response.data)
                        )
                    )
                }
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// MARK: Single

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    public func map<D: Decodable>(to type: D.Type) -> Single<D> {
        return flatMap { response -> Single<D> in
            return .just(try response.map(to: type))
        }
    }

}

// MARK: Observable

extension ObservableType where E == Response {
    public func map<D: Decodable>(to type: D.Type) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            return .just(try response.map(to: type))
        }
    }
}
