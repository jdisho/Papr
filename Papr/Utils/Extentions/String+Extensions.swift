//
//  String+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 06.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }

    func nsRange(of searchString: String) -> NSRange? {
        let nsString = self as NSString
        let range = nsString.range(of: searchString)
        return range.location != NSNotFound ? range : nil
    }

    func attributedString(withHighlightedText text: String, color: UIColor = Papr.Appearance.Color.yellowZ) -> NSAttributedString {
        guard let range = lowercased().nsRange(of: text.lowercased()) else {
            return NSAttributedString(string: self)
        }

        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)

        return attributedString
    }

}
