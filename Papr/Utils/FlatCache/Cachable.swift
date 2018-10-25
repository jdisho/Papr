//
//  Cachable.swift
//  Papr
//
//  Created by Joan Disho on 25.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String { get }
}

protocol Cachable: Identifiable { }

extension Cachable {
    static var typeName: String {
        return String(describing: self)
    }

    var flatCacheKey: FlatCacheKey {
        return FlatCacheKey(typeName: Self.typeName, id: id)
    }
}
