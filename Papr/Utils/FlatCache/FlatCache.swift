//
//  FlatCache.swift
//  Papr
//
//  Created by Joan Disho on 25.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//


/***https://github.com/GitHawkApp/FlatCache/blob/master/FlatCache/FlatCache.swift ***/

import Foundation

protocol FlatCacheListener: class {
    func flatCacheDidUpdate(cache: FlatCache, update: FlatCache.Update)
}

final class FlatCache {

    static let shared = FlatCache()

    enum Update {
        case item(Any)
        case list([Any])
        case clear
    }

    private var storage: [FlatCacheKey: Any] = [:]
    private let queue = DispatchQueue(
        label: "com.papr.FlatCache.queue",
        qos: .userInitiated,
        attributes: .concurrent
    )

    private var listeners: [FlatCacheKey: NSHashTable<AnyObject>] = [:]

    public init() { }

    func add<T: Cachable>(listener: FlatCacheListener, value: T) {
        assert(Thread.isMainThread)

        let key = value.flatCacheKey
        let table: NSHashTable<AnyObject>
        if let existing = listeners[key] {
            table = existing
        } else {
            table = NSHashTable.weakObjects()
        }
        table.add(listener)
        listeners[key] = table
    }

    func set<T: Cachable>(value: T) {
        assert(Thread.isMainThread)

        let key = value.flatCacheKey
        storage[key] = value

        enumerateListeners(key: key) { listener in
            listener.flatCacheDidUpdate(cache: self, update: .item(value))
        }
    }

    public func set<T: Cachable>(values: [T]) {
        assert(Thread.isMainThread)

        var listenerHashToValuesMap = [Int: [T]]()
        var listenerHashToListenerMap = [Int: FlatCacheListener]()

        for value in values {
            let key = value.flatCacheKey
            storage[key] = value

            enumerateListeners(key: key, block: { listener in
                let hash = ObjectIdentifier(listener).hashValue
                if var arr = listenerHashToValuesMap[hash] {
                    arr.append(value)
                    listenerHashToValuesMap[hash] = arr
                } else {
                    listenerHashToValuesMap[hash] = [value]
                }
                listenerHashToListenerMap[hash] = listener
            })
        }

        for (hash, arr) in listenerHashToValuesMap {
            guard let listener = listenerHashToListenerMap[hash] else { continue }
            if arr.count == 1, let first = arr.first {
                listener.flatCacheDidUpdate(cache: self, update: .item(first))
            } else {
                listener.flatCacheDidUpdate(cache: self, update: .list(arr))
            }
        }
    }

    func get<T: Cachable>(id: String) -> T? {
        assert(Thread.isMainThread)

        let key = FlatCacheKey(typeName: T.typeName, id: id)
        return storage[key] as? T
    }

    func clear() {
        assert(Thread.isMainThread)

        storage = [:]

        for key in listeners.keys {
            enumerateListeners(key: key) { listener in
                listener.flatCacheDidUpdate(cache: self, update: .clear)
            }
        }
    }

    private func enumerateListeners(key: FlatCacheKey, block: (FlatCacheListener) -> ()) {
        assert(Thread.isMainThread)

        if let table = listeners[key] {
            for object in table.objectEnumerator() {
                if let listener = object as? FlatCacheListener {
                    block(listener)
                }
            }
        }
    }


}
