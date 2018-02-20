//
//  UIImageView+Extentions.swift
//  Papr
//
//  Created by Joan Disho on 05.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

extension UIImageView {

    func rounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
