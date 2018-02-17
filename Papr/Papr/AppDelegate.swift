//
//  AppDelegate.swift
//  Papr
//
//  Created by Joan Disho on 30.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let sceneCoordinator = SceneCoordinator(window: window!)
        SceneCoordinator.shared = sceneCoordinator

        if KeychainSwift().get(UnsplashSettings.clientID.string) != nil {
            let homeScene = Scene.home(HomeViewModel())
            sceneCoordinator.transition(to: homeScene, type: .root)
        } else {
            let loginScene = Scene.login(LoginViewModel())
            sceneCoordinator.transition(to: loginScene, type: .root)
        }
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}

