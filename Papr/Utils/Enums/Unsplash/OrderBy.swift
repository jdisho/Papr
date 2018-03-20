//
//  OrderBy.swift
//  Papr
//
//  Created by Joan Disho on 04.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

enum OrderBy {
    case latest
    case oldest
    case popular
    
    var string: String {
        switch self {
        case .latest:
            return "latest"
        case .oldest:
            return "oldest"
        case .popular:
            return "popular"
        }
    }
}
