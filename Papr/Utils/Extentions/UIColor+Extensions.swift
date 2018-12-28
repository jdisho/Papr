//
//  UIColor+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 03.06.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init?(hexString: String, alpha: Double = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 {
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        var a = alpha
        if a < 0 { a = 0 }
        if a > 1 { a = 1 }

        let red = CGFloat((hexValue >> 16) & 0xff) / 255
        let green = CGFloat((hexValue >> 8) & 0xff) / 255
        let blue = CGFloat(hexValue & 0xff) / 255

        self.init(red: red, green: green, blue: blue, alpha: CGFloat(a))
    }

    func toImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
