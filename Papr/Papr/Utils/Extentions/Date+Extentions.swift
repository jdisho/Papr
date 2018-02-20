//
//  Date+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 06.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

enum DateRepresentation {
    case second
    case minute
    case hour
    case day
}

extension Date {
    
    func since(_ anotherTime: Date, in representation: DateRepresentation) -> Double {
        switch representation {
        case .second: return -timeIntervalSince(anotherTime)
        case .minute: return -timeIntervalSince(anotherTime) / 60
        case .hour: return -timeIntervalSince(anotherTime) / 3600
        case .day: return -timeIntervalSince(anotherTime) / (24 * 3600)
        }
    }
}
