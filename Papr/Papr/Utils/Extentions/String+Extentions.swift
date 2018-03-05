//
//  String+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 06.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

extension String {
    
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }

}
