//
//  UIView+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 05.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

extension UIView {

    func rounded(withRadius radius: Double) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
}
