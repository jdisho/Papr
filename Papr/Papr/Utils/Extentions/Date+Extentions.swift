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
    
    func since(_ anotherTime: Date,
               in representation: DateRepresentation) -> Double {
        switch representation {
        case .second:   return -timeIntervalSince(anotherTime)
        case .minute:   return -timeIntervalSince(anotherTime) / 60
        case .hour:     return -timeIntervalSince(anotherTime) / (60 * 60)
        case .day:      return -timeIntervalSince(anotherTime) / (24 * 60 * 60)
        case .week:     return -timeIntervalSince(anotherTime) / (7 * 24 * 60 * 60)
        case .month:    return -timeIntervalSince(anotherTime) / (30 * 24 * 60 * 60)
        case .year:     return -timeIntervalSince(anotherTime) / (365 * 24 * 60 * 60)
        }
    }

    var abbreviated: String {
        let roundedDate = self.since(Date(), in: .minute).rounded()
        if roundedDate >= 60.0 && roundedDate < 24 * 60.0 {
            return "\(Int(self.since(Date(), in: .hour).rounded()))h"
        } else if roundedDate >= 24 * 60.0 && roundedDate < 7 * 24 * 60 {
            return "\(Int(self.since(Date(), in: .day).rounded()))d"
        } else if roundedDate >= 7 * 24 * 60.0 && roundedDate < 30 * 24 * 60 {
            return "\(Int(self.since(Date(), in: .week).rounded()))w"
        } else if roundedDate >= 30 * 24 * 60 && roundedDate < 365 * 24 * 60 {
            return "\(Int(self.since(Date(), in: .month).rounded()))mo"
        } else if roundedDate >= 365 * 24 * 60 {
            return "\(Int(self.since(Date(), in: .year).rounded()))y"
        }
        return "\(Int(roundedDate))min"
    }
}
