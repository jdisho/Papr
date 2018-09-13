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
            let paprTabBarController = PaprTabBarController()

            //HomeViewController
            var homeVC = HomeViewController.initFromNib()
            let rootHomeVC = UINavigationController(rootViewController: homeVC)
            homeVC.bind(to: HomeViewModel())

            //SearchViewController
            var searchVC = SearchViewController.initFromNib()
            let rootSearchVC = UINavigationController(rootViewController: searchVC)
            searchVC.bind(to: SearchViewModel())

            //CollectionsViewController
            var collectionsVC = CollectionsViewController()
            let rootCollectionVC = UINavigationController(rootViewController: collectionsVC)
            collectionsVC.bind(to: CollectionsViewModel())

            rootHomeVC.tabBarItem = UITabBarItem(title: "Photos", image: #imageLiteral(resourceName: "photo-black"), tag: 0)
            rootCollectionVC.tabBarItem = UITabBarItem(title: "Collections", image: #imageLiteral(resourceName: "collections-black"), tag: 1)
            rootSearchVC.tabBarItem = UITabBarItem.init(title: "Search", image: #imageLiteral(resourceName: "search-black"), tag: 2)

            paprTabBarController.viewControllers = [
                rootHomeVC,
                rootCollectionVC,
                rootSearchVC
            ]
            return .tabBar(paprTabBarController)
        case let .login(viewModel):
            var vc = LoginViewController.initFromNib()
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
            var vc = PhotoDetailsViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .addToCollection(viewModel):
            var vc = AddToCollectionViewController.initFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            vc.bind(to: viewModel)
            return .present(rootViewController)
        case let .createCollection(viewModel):
            var vc = CreateCollectionViewController.initFromNib()
            let rootViewController = UINavigationController(rootViewController: vc)
            vc.bind(to: viewModel)
            return .present(rootViewController)
        case let .searchPhotos(viewModel):
            var vc = SearchPhotosViewController.initFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .searchCollections(viewModel):
            var vc = SearchCollectionsViewController.initFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .searchUsers(viewModel):
            var vc = SearchUsersViewController.initFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        }
    }
}

