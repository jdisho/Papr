//
//  Single+Mapper.swift
//
//  Created by Joan Disho on 22.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Mapper

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func map<T: Mappable>(to type: T.Type, keyPath: String? = nil) -> Single<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<T> in
                return Single.just(try response.map(to: type, keyPath: keyPath))
            }
            .observeOn(MainScheduler.instance)
    }
    
    func map<T: Mappable>(to type: [T].Type, keyPath: String? = nil) -> Single<[T]> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<[T]> in 
                return Single.just(try response.map(to: type, keyPath: keyPath))
            }
            .observeOn(MainScheduler.instance)
    }
    
     func mapOptional<T: Mappable>(to type: T.Type, keyPath: String? = nil) -> Single<T?> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<T?> in
                do {
                    let object = try response.map(to: type, keyPath: keyPath)
                    return Single.just(object)
                } catch {
                    return Single.just(nil)
                }
            }
            .observeOn(MainScheduler.instance)
    }
    
    func mapOptional<T: Mappable>(to type: [T].Type, keyPath: String? = nil) -> Single<[T]?> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<[T]?> in 
                do {
                    let object = try response.map(to: type, keyPath: keyPath)
                    return Single.just(object)
                } catch {
                    return Single.just(nil)
                }
            }
            .observeOn(MainScheduler.instance)
    }
    
}
