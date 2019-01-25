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
    var identifier: String { get }
}

public protocol Cachable: Identifiable, Equatable { }

private extension Cachable {
    static var typeName: String {
        return String(describing: self)
    }

    var cacheKey: CacheKey {
        return CacheKey(typeName: Self.typeName, id: identifier)
    }
}

public final class Cache  {

    public static let shared = Cache()

    private let storageStream = PublishSubject<[(key: CacheKey, value: Any)]>()
    private var storage = [(key: CacheKey, value: Any)]()

    public init() { }

    public func set<T: Cachable>(value: T) {
        populate(storage: &storage, with: value)
        storageStream.onNext(storage)
    }

    public func set<T: Cachable>(values: [T]) {
        for value in values {
            populate(storage: &storage, with: value)
        }

        storageStream.onNext(storage)
    }

    public func getObject<T>(ofType type: T.Type, withId id: String) -> Observable<T?> where T: Cachable {
        let cacheKey = CacheKey(typeName: type.typeName, id: id)
        return storageStream.map { $0.first(where: { $0.key == cacheKey }).flatMap { $0.value as? T } }
    }

    public func getAllObjects<T: Cachable>(ofType type: T.Type) -> Observable<[T]> {
        return storageStream.map { $0.map { $0.value as? T }.compactMap { $0 }}
    }

    public func clear() {
        if !storage.isEmpty {
            print("Cache is cleared 🧻")
            storage.removeAll()
            storageStream.onNext(storage)
        }
    }

    private func populate<T: Cachable>(storage: inout [(key: CacheKey, value: Any)], with value: T) {
        let values = storage.map { $0.value as? T }.compactMap { $0 }
        if let foundedValue = values.first(where: { $0.cacheKey.id == value.cacheKey.id }),
            let index = values.firstIndex(of: foundedValue) {
            storage[index] = (key: value.cacheKey, value: value)
        } else {
            storage.append((key: value.cacheKey, value: value))
        }
    }
}
