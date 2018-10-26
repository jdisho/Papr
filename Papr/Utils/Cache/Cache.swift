//
//  Cache.swift
//  Papr
//
//  Created by Joan Disho on 25.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

public struct CacheKey: Equatable, Hashable {

    let typeName: String
    let id: String

    public static func == (lhs: CacheKey, rhs: CacheKey) -> Bool {
        return lhs.typeName == rhs.typeName && lhs.id == rhs.id
    }

    public var hashValue: Int {
        return typeName.hashValue ^ id.hashValue
    }
}

public protocol Identifiable {
    var id: String { get }
}

public protocol Cachable: Identifiable { }

private extension Cachable {
    static var typeName: String {
        return String(describing: self)
    }

    var cacheKey: CacheKey {
        return CacheKey(typeName: Self.typeName, id: id)
    }
}

public final class Cache  {

    private let storageStream = PublishSubject<[CacheKey: Any]>()
    private var storage = [CacheKey: Any]()

    public init() { }

    public func set<T: Cachable>(value: T) {
        let key = value.cacheKey
        storage[key] = value

        storageStream.onNext(storage)
    }

    public func set<T: Cachable>(values: [T]) {
        for value in values {
            let key = value.cacheKey
            storage[key] = value
        }
        storageStream.onNext(storage)
    }

    public func collection<T: Cachable>() -> Observable<[T]> {
        return storageStream.map { $0.values.map { $0 as? T }.compactMap { $0 } }
    }

    public func clear() {
        storage.removeAll()
        storageStream.onNext([:])
    }
}
