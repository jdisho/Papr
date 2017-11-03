//
//  Observable+Mapper.swift
//
//  Created by Joan Disho on 22.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Mapper


public extension ObservableType where E == Response {
          
    public func map<T: Mappable>(to type: T.Type, keyPath: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.map(to: type, keyPath: keyPath))
        }
    }
    
    public func map<T: Mappable>(to type: [T].Type, keyPath: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.map(to: type, keyPath: keyPath))
        }
    }
    
    public func mapOptional<T: Mappable>(to type: T.Type, keyPath: String? = nil) -> Observable<T?> {
        return flatMap { response -> Observable<T?> in
            do {
                let object = try response.map(to: type, keyPath: keyPath)
                return Observable.just(object)
            } catch {
                return Observable.just(nil)
            }   
        }
    }
    
    public func mapOptional<T: Mappable>(to type: [T].Type, keyPath: String? = nil) -> Observable<[T]?> {
        return flatMap { response -> Observable<[T]?> in
            do {
                let object = try response.map(to: type, keyPath: keyPath)
                return Observable.just(object)
            } catch {
                return Observable.just(nil)
            }   
        }
    }
    
}
