//
//  ButtonRounded.swift
//  Papr
//
//  Created by imo on 6.05.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

enum ButtonRoundedStyle {
    case border, fill
}

class ButtonRounded: UIButton {
    
    var style: ButtonRoundedStyle = .border
    
    public func configure(type: ButtonRoundedStyle) {
        style = type
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = Constants.Appearance.Style.imageCornersRadius
        backgroundColor = .clear
        
        if style == .border {
            layer.borderWidth = Constants.Appearance.Style.imageCornersRadiusWidth
            layer.borderColor = UIColor.black.cgColor
            layer.backgroundColor = UIColor.white.cgColor
            
            setTitleColor(.black, for: .normal)
            
        } else {
            layer.borderColor = UIColor.clear.cgColor
            layer.backgroundColor = UIColor.black.cgColor
            
            setTitleColor(.white, for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        borderDissapear(highlighted: true)
        titleDissapear(highlighted: true)
        backgroundDissapear(highlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        borderDissapear(highlighted: false)
        titleDissapear(highlighted: false)
        backgroundDissapear(highlighted: false)
    }
    
    func borderDissapear (highlighted: Bool) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.duration = 0.1
        animation.autoreverses = false
        animation.repeatCount = 1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        if highlighted {
            animation.fromValue = self.layer.borderColor?.copy(alpha: 1)
            animation.toValue = self.layer.borderColor?.copy(alpha: 0.3)
        } else if !highlighted {
            animation.fromValue = self.layer.borderColor?.copy(alpha: 0.3)
            animation.toValue = self.layer.borderColor?.copy(alpha: 1)
        }
        self.layer.add(animation, forKey: "borderColor")
    }
    
    func titleDissapear (highlighted: Bool) {
        if !highlighted {
            self.titleLabel?.textColor = self.titleLabel?.textColor.withAlphaComponent(0.3)
        } else {
            self.titleLabel?.textColor = self.titleLabel?.textColor.withAlphaComponent(1)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            if highlighted {
                self.titleLabel?.textColor = self.titleLabel?.textColor.withAlphaComponent(0.3)
            } else {
                self.titleLabel?.textColor = self.titleLabel?.textColor.withAlphaComponent(1)
            }
        }, completion: nil)
    }
    
    func backgroundDissapear (highlighted: Bool) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.duration = 0.1
        animation.autoreverses = false
        animation.repeatCount = 1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        if highlighted {
            animation.fromValue = self.layer.backgroundColor?.copy(alpha: 1)
            animation.toValue = self.layer.backgroundColor?.copy(alpha: 0.3)
        } else if !highlighted {
            animation.fromValue = self.layer.backgroundColor?.copy(alpha: 0.3)
            animation.toValue = self.layer.backgroundColor?.copy(alpha: 1)
        }
        self.layer.add(animation, forKey: "backgroundColor")
    }
    
}
