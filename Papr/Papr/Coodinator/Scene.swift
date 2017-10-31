//
//  Scene.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit

/**
     Refers to a screen managed by a view controller.
     It can be a regular screen, or a modal dialog.
     It comprises a view controller and a view model.
 */


enum Scene {
    case initialView(InitialViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .initialView(let viewModel):
            var vc = InitialViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return vc
        }
    }
}

