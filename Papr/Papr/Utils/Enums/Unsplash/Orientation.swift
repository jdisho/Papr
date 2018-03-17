//
//  Orientation.swift
//  Papr
//
//  Created by Joan Disho on 15.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

enum Orientation {
    case landscape
    case portrait
    case squarish
    
    var string: String {
        switch self {
        case .landscape:
            return "landscape"
        case .portrait:
            return "portrait"
        case .squarish:
            return "squarish"
        }
    }
}
