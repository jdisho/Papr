//
//  ClassIdentifiable.swift
//  Papr
//
//  Created by Joan Disho on 22.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

protocol ClassIdentifiable: class {
    static var reuseId: String { get }
}

extension ClassIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}
