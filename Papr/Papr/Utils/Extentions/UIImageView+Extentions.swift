//
//  UIImageView+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 05.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    var rounded: Void {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
