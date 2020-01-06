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

class SceneCoordinator: NSObject, SceneCoordinatorType {
    
    static var shared: SceneCoordinator!
    
    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController {
        didSet {
            currentViewController.navigationController?.delegate = self
            currentViewController.tabBarController?.delegate = self
        }
    }
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        var controller = viewController
        if let tabBarController = controller as? UITabBarController {
            guard let selectedViewController = tabBarController.selectedViewController else {
                return tabBarController
            }
            controller = selectedViewController
            
            return actualViewController(for: controller)
        }

        if let navigationController = viewController as? UINavigationController {
            controller = navigationController.viewControllers.first!
            
            return actualViewController(for: controller)
        }
        return controller
    }
    
    @discardableResult
    func transition(to scene: TargetScene) -> Observable<Void> {
        let subject = PublishSubject<Void>()

        switch scene.transition {
        case let .tabBar(tabBarController):
            guard let selectedViewController = tabBarController.selectedViewController else {
               fatalError("Selected view controller doesn't exists")
            }
            currentViewController = SceneCoordinator.actualViewController(for: selectedViewController)
            window.rootViewController = tabBarController
        case let .root(viewController):
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
        case let .push(viewController):
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }

            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .ignoreAll()
                .bind(to: subject)

            navigationController.pushViewController(SceneCoordinator.actualViewController(for: viewController), animated: true)
        case let .present(viewController):
            viewController.modalPresentationStyle = .fullScreen
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
        case let .alert(viewController):
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
        var isDisposed = false
        var currentObserver: AnyObserver<Void>?
        let source = Observable<Void>.create { observer in
            currentObserver = observer
            return Disposables.create {
                isDisposed = true
            }
        }

        if let presentingViewController = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                if !isDisposed {
                    self.currentViewController = SceneCoordinator.actualViewController(for: presentingViewController)
                }
                currentObserver?.on(.completed)
            }
        } else if let navigationController = currentViewController.navigationController {
            _ = navigationController
                .rx
                .delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .ignoreAll()
                .bind(to: currentObserver!)
            
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }

            if !isDisposed {
                currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
            }
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }

        return source
            .take(1)
            .ignoreAll()
    }
}

// MARK: - UINavigationControllerDelegate

extension SceneCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
    }
}

// MARK: - UITabBarControllerDelegate

extension SceneCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)  {
        currentViewController = SceneCoordinator.actualViewController(for: viewController)
    }
}
