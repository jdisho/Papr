//
//  UIView+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 05.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

extension UIView {
    var cornerRadius: Double {
        get {
            return Double(layer.cornerRadius)
        }
        set {
            layer.masksToBounds = false
            layer.cornerRadius = CGFloat(newValue)
            clipsToBounds = true
        }
    }

    var borderColor: CGColor? {
        get {
            return layer.borderColor
        }
        set {
            layer.borderColor = newValue
        }
    }

    var borderWidth: Double {
        get {
            return Double(layer.borderWidth)
        }
        set {
            layer.borderWidth = CGFloat(newValue)
        }
    }
}
