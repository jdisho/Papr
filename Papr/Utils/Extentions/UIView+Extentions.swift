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

    func blur(withStyle style: UIBlurEffectStyle = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = bounds
        blurredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurredView)
        clipsToBounds = true
    }

    func round(corners: UIRectCorner = .allCorners, radius: CGFloat = 5.0) {
        let rect = CAShapeLayer()
        rect.frame = bounds
        rect.position = center
        rect.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.mask = rect
    }
}
