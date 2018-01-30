//
//  ViewModelType.swift
//  Papr
//
//  Created by Joan Disho on 22.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
