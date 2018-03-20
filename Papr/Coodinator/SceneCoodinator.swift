//
//  SceneCoodinator.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 Scene coordinator, manage scene navigation and presentation.
 */

class SceneCoordinator: SceneCoordinatorType {
    
    static var shared: SceneCoordinator!
    
    private var window: UIWindow
    private var currentViewController: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        }
        return viewController
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        
        switch type {
        case .root:
            currentViewController = actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
        case .push:
            guard let navigationController = viewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            _ = navigationController
                .rx
                .delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map{_ in }
                .bind(to: subject)
            
            navigationController.pushViewController(viewController, animated: true)
            currentViewController = actualViewController(for: viewController)
        case .modal:
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentViewController = actualViewController(for: viewController)
        case .alert:
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
        }
        
        return subject
            .asObservable()
            .take(1)
    }
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = self.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            
            _ = navigationController
                .rx
                .delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
            
            currentViewController = actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
        
        return subject
            .asObservable()
            .take(1)
    }
}

