//
//  MoyaProvider+Rx.swift
//  ghIssues
//
//  Created by Joan Disho on 21.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {
    
    public func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return base.rxRequest(token, callbackQueue: callbackQueue)
    }
    
}

internal extension MoyaProviderType {
    
    internal func rxRequest(_ token: Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create { [weak self] single in
            let token = self?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(respose):
                    single(.success(respose))
                case let .failure(error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                token?.cancel()
            }
        }
    }
    
}

