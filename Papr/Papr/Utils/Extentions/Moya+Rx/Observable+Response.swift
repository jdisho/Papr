//
//  Observable+Response.swift
//  ghIssues
//
//  Created by Joan Disho on 21.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public extension ObservableType where E == Response {
    
    // Filters out responses that don't fall within the given range, generating errors when others are encountered.
    public func filter(statusCodes: ClosedRange<Int>) -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.filter(statusCodes: statusCodes))
        }
    }
    
    public func filter(statusCode: Int) -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.filter(statusCode: statusCode))
        }
    }
    
    public func filterSuccessfulStatusCodes() -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.filterSuccessfulStatusCodes())
        }
    }
    
    public func filterSuccessfulStatusAndRedirectCodes() -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.filterSuccessfulStatusAndRedirectCodes())
        }
    }
    
    // Maps data received from the signal into an Image. If the conversion fails, the signal errors.
    public func mapImage() -> Observable<Image?> {
        return flatMap { response -> Observable<Image?> in
            return Observable.just(try response.mapImage())
        }
    }
    
    // Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    public func mapJSON(failsOnEmptyData: Bool = true) -> Observable<Any> {
        return flatMap { response -> Observable<Any> in
            return Observable.just(try response.mapJSON(failsOnEmptyData: failsOnEmptyData))
        }
    }
    
    // Maps received data at key path into a String. If the conversion fails, the signal errors.
    public func mapString(atKeyPath keyPath: String? = nil) -> Observable<String> {
        return flatMap { response -> Observable<String> in
            return Observable.just(try response.mapString(atKeyPath: keyPath))
        }
    }
    
    // Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    public func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            return Observable.just(try response.map(type, atKeyPath: keyPath, using: decoder))
        }
    }
    
    
}

