//
//  ObservableType+Extras.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func ignoreAll() -> Observable<Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> Observable<T> where Element == T? {
        return compactMap { $0 }
    }

    func execute(_ selector: @escaping (Element) -> Void) -> Observable<Element> {
        return flatMap { result in
             return Observable
                .just(selector(result))
                .map { _ in result }
                .take(1)
        }
    }

    func count() -> Observable<(Element, Int)>{
        var numberOfTimesCalled = 0
        let result = map { _ -> Int in
            numberOfTimesCalled += 1
            return numberOfTimesCalled
        }

        return Observable.combineLatest(self, result)
    }

    func merge(with other: Observable<Element>) -> Observable<Element> {
        return Observable.merge(self.asObservable(), other)
    }
    
    func orEmpty() -> Observable<Element> {
        return catchError { _ in
            return .empty()
        }
    }
    
    func map<T>(to value: T) -> Observable<T> {
        return map { _ in value }
    }
    
}
extension Observable where Element == String {
    func mapToURL() -> Observable<URL> {
        return map { URL(string: $0) }.compactMap { $0 }
    }
}
extension Observable where Element == Data {
    func map<D: Decodable>( _ type: D.Type) -> Observable<D>  {
        return map { try JSONDecoder().decode(type, from: $0) }
    }
}

extension Observable where Element == Bool {
    
    func negate() -> Observable<Bool> {
        return map { !$0 }
    }

}

extension Observable where Element: Sequence, Element.Iterator.Element: Comparable {
    
    /**
     Transforms an observable of sequences into an observable of ordered arrays by using the sequence element's
     natural comparator.
     */
    
    func sorted<T>() -> Observable<[T]> where Element.Iterator.Element == T {
        return map { $0.sorted() }
    }
    
    func sorted<T>(_ areInIncreasingOrder: @escaping (T, T) -> Bool) -> Observable<[T]> 
        where Element.Iterator.Element == T {
            return map { $0.sorted(by: areInIncreasingOrder) }
    }
}


extension ObservableType where Element: Collection {

    func mapMany<T>(_ transform: @escaping (Self.Element.Element) -> T) -> Observable<[T]> {
        return self.map { collection -> [T] in
            collection.map(transform)
        }
    }
}
