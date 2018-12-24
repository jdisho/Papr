//
//  UIImage+Extensions.swift
//  Papr
//
//  Created by Joan Disho on 24.12.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static func fromColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
