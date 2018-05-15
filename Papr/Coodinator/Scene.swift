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

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case papr
    case login(LoginViewModel)
    case alert(AlertViewModel)
    case activity([Any])
    case photoDetails(PhotoDetailsViewModel)
    case addToCollection(AddToCollectionViewModel)
    case createCollection(CreateCollectionViewModel)
    case searchPhotos(SearchPhotosViewModel)
    case searchCollections(SearchCollectionsViewModel)
    case searchUsers(SearchUsersViewModel)
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .papr:
            let paprTabBarController = PaprTabBarController.instantiateFromNib()

            // MARK: HomeViewController
            var homeVC = HomeViewController.instantiateFromNib()
            let rootHomeVC = UINavigationController(rootViewController: homeVC)
            homeVC.bind(to: HomeViewModel())

            // MARK: SearchViewController
            var searchVC = SearchViewController.instantiateFromNib()
            let rootSearchVC = UINavigationController(rootViewController: searchVC)
            searchVC.bind(to: SearchViewModel())

            rootHomeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
            rootSearchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

            paprTabBarController.viewControllers = [
                rootHomeVC,
                rootSearchVC
            ]
            return .tabBar(paprTabBarController)
        case let .login(viewModel):
            var vc = LoginViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .alert(viewModel):
            var vc = AlertViewController(title: nil, message: nil, preferredStyle: .alert)
            vc.bind(to: viewModel)
            return .alert(vc)
        case let .activity(items):
            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            return .alert(vc)
        case let .photoDetails(viewModel):
            var vc = PhotoDetailsViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .addToCollection(viewModel):
            var vc = AddToCollectionViewController.instantiateFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            vc.bind(to: viewModel)
            return .present(rootViewController)
        case let .createCollection(viewModel):
            var vc = CreateCollectionViewController.instantiateFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            vc.bind(to: viewModel)
            return .present(rootViewController)
        case let .searchPhotos(viewModel):
            var vc = SearchPhotosViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .searchCollections(viewModel):
            var vc = SearchCollectionsViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .searchUsers(viewModel):
            var vc = SearchUsersViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        }
    }
}

