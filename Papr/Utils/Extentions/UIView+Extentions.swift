//
//  UIView+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 05.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

extension UIView {
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

    func dim(withAlpha alpha: CGFloat) {
        let view = UIView(frame: bounds)
        view.backgroundColor = .black
        view.alpha = alpha
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        clipsToBounds = true
    }

    func round(corners: UIRectCorner = .allCorners, radius: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
