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
        target: Base.Target,
        session: URLSession = URLSession.shared
        ) -> Single<Decodable> {
        return Single.create { single in
            let task = self.base.request(target: target, session: session) { result in
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
