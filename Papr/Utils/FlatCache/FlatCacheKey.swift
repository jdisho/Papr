//
//  FlatCacheKey.swift
//  Papr
//
//  Created by Joan Disho on 25.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

struct FlatCacheKey: Equatable, Hashable {

    let typeName: String
    let id: String

    static func == (lhs: FlatCacheKey, rhs: FlatCacheKey) -> Bool {
        return lhs.typeName == rhs.typeName && lhs.id == rhs.id
    }

    var hashValue: Int {
        return typeName.hashValue ^ id.hashValue
    }
}
