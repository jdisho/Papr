//
//  UserProfileButtonManager.swift
//  Papr
//
//  Created by Joan Disho on 22.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

class UserProfileButtonManager: NSObject {
    private var navigationController: UINavigationController?

    init(nc: UINavigationController) {
        super.init()
        let allowedVC = nc.viewControllers.first(where: { $0 is HomeViewController })
        if allowedVC != nil {
            allowedVC!.navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Profile",
                style: .plain,
                target: self,
                action: nil
            )
        }
    }
}
