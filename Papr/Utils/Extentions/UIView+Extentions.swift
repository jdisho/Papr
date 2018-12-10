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

    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = bounds
        blurredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurredView)
        clipsToBounds = true
    }

    func round(corners: UIRectCorner = .allCorners, radius: CGFloat = 5.0) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.position = center
        shapeLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.mask = shapeLayer
    }

    func dim(withAlpha alpha: CGFloat) {
        let view = UIView(frame: bounds)
        view.backgroundColor = .black
        view.alpha = alpha
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        clipsToBounds = true
    }
}
