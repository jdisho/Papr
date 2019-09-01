//
//  PaprTabBarController.swift
//  Papr
//
//  Created by Joan Disho on 13.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

class PaprTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .white
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        }
    }
}
