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
    case login(LoginViewModel)
    case home(HomeViewModel)
    case alert(AlertViewModel)
    case photoDetails(PhotoDetailsViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case let .login(viewModel):
            var vc = LoginViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return vc
        case let .home(viewModel):
            var vc = HomeViewController.instantiateFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            vc.bind(to: viewModel)
            return rootViewController
        case let .alert(viewModel):
            var vc = AlertViewController(title: nil, message: nil, preferredStyle: .alert)
            vc.bind(to: viewModel)
            return vc
        case let .photoDetails(viewModel):
            var vc = PhotoDetailsViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return vc
        }
    }
}

