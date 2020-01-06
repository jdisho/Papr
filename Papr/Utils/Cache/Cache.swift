//
//  Cache.swift
//  Papr
//
//  Created by Joan Disho on 25.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

struct CacheKey: Equatable, Hashable {
    let typeName: String
    let id: String
}

protocol Identifiable {
    var identifier: String { get }
}

protocol Cachable: Identifiable, Equatable { }

private extension Cachable {
    static var typeName: String {
        return String(describing: self)
    }

    var cacheKey: CacheKey {
        return CacheKey(typeName: Self.typeName, id: identifier)
    }
}

final class Cache  {

    static let shared = Cache()

    private let storageStream = PublishSubject<[(key: CacheKey, value: Any)]>()
    private var storage = [(key: CacheKey, value: Any)]()

    private init() {}

    func set<T: Cachable>(value: T) {
        storage.insert(value)
        storageStream.onNext(storage)
    }

    func set<T: Cachable>(values: [T]) {
        values.forEach { storage.insert($0) }
        storageStream.onNext(storage)
    }

    func getObject<T: Cachable>(ofType type: T.Type, withId id: String) -> Observable<T?> {
        let cacheKey = CacheKey(typeName: type.typeName, id: id)
        return storageStream
            .map { $0.first(where: { $0.key == cacheKey })?.value as? T }
            .startWith(nil)
    }

    func getAllObjects<T: Cachable>(ofType type: T.Type) -> Observable<[T]> {
        return storageStream
            .map { $0.map { $0.value as? T }.compactMap { $0 } }
            .startWith([])
    }

    func clear() {
        guard !storage.isEmpty else { return }
        print("🚽: Cache is cleared")
        storage.removeAll()
        storageStream.onNext(storage)
    }

}

private extension Array where Element == (key: CacheKey, value: Any) {

    mutating func insert<T: Cachable>(_ value: T) {
        let values = map { $0.value as? T }.compactMap { $0 }

        if let foundedValue = values.first(where: { $0.cacheKey.id == value.cacheKey.id }),
            let index = values.firstIndex(of: foundedValue) {
            self[index] = (key: value.cacheKey, value: value)
        } else {
            append((key: value.cacheKey, value: value))
        }
    }
}
