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
    case week
    case month
    case year
}

extension Date {
    
    func since(_ anotherTime: Date, in representation: DateRepresentation) -> Double {
        let timeIntervalSinceTime = -timeIntervalSince(anotherTime)
        switch representation {
        case .second:   return timeIntervalSinceTime
        case .minute:   return timeIntervalSinceTime / 60
        case .hour:     return timeIntervalSinceTime / 60 * 60
        case .day:      return timeIntervalSinceTime / 24 * 60 * 60
        case .week:     return timeIntervalSinceTime / 7 * 24 * 60 * 60
        case .month:    return timeIntervalSinceTime / 30 * 24 * 60 * 60
        case .year:     return timeIntervalSinceTime / 365 * 24 * 60 * 60
        }
    }
}
