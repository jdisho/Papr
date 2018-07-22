//
//  ProfileButtonManager.swift
//  Papr
//
//  Created by Joan Disho on 21.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

class ProfileButtonManager: NSObject, UINavigationControllerDelegate {
    private var navController: UINavigationController?

    override init() {
        super.init()
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
        ) {
        navController = navigationController
        let tabVC = navigationController.viewControllers.first(where: { $0 is PaprTabBarController })
        if tabVC != nil {
            print("NOT NIIIIIL")
        }
    }
}
