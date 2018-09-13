//
//  Result.swift
//  Papr
//
//  Created by Joan Disho on 27.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public enum Result<T, E> {
    case success(T)
    case error(E)
}
