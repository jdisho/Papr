//
//  Resolution.swift
//  Papr
//
//  Created by Joan Disho on 19.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

// Currently, the only resolution supported is “days”. 
// Unsplash probably will add more later.

enum Resolution {
    case days

    var value: String {
        switch self {
        case .days:
            return "days"
        }
    }
}
