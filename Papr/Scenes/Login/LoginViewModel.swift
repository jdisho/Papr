//
//  Login.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action
import SafariServices

enum LoginState {
    case idle
    case fetchingToken
    case tokenIsFetched
}

protocol LoginViewModelInput {
    var loginAction: CocoaAction { get }
    var closeAction: CocoaAction { get }
}

protocol LoginViewModelOuput {
    var buttonName: Observable<String> { get }
    var loginState: Observable<LoginState> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOuput { get }
}

class LoginViewModel: LoginViewModelInput, LoginViewModelOuput, LoginViewModelType   {

    // MARK: Inputs & Outputs
    var inputs: LoginViewModelInput { return self }
    var outputs: LoginViewModelOuput { return self }

    // MARK: Input
    lazy var loginAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            self.authenticate()
        }
    }()

    lazy var closeAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            self.sceneCoordinator.pop(animated: true)
        }
    }()

    // MARK: Output
    let buttonName: Observable<String>
    let loginState: Observable<LoginState>
    
    // MARK: Private
    fileprivate let authManager: UnsplashAuthManager
    private let service: UserServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private var _authSession: Any?
    @available(iOS 11.0, *)
    private var authSession: SFAuthenticationSession? {
        get {
            return _authSession as? SFAuthenticationSession
        }
        set {
            _authSession = newValue
        }
    }

    private let buttonNameProperty = BehaviorSubject<String>(value: "Login with Unsplash")
    private let loginStateProperty = BehaviorSubject<LoginState>(value: .idle)

    // MARK: Init
    init(service: UserServiceType = UserService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared,
         authManager: UnsplashAuthManager = UnsplashAuthManager.sharedAuthManager) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
        self.authManager = authManager

        loginState = loginStateProperty.asObservable()
        buttonName = buttonNameProperty.asObservable()

        self.authManager.delegate = self
    }
    
    // MARK: Private
    
    private lazy var navigateToTabBarAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            return self.sceneCoordinator.transition(to: Scene.papr)
            }
    }()

    private lazy var alertAction: Action<String, Void> = {
        Action<String, Void> { [unowned self] message in
            let alertViewModel = AlertViewModel(
                title: "Upsss...",
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()

    
    private func authenticate() -> Observable<Void> {        
        if #available(iOS 11.0, *) {
            self.authSession = SFAuthenticationSession(
                url: authManager.authURL,
                callbackURLScheme: UnsplashSettings.callbackURLScheme.string,
                completionHandler: { [weak self] (callbackUrl, error) in
                guard error == nil, let callbackUrl = callbackUrl else {
                    switch error! {
                    case SFAuthenticationError.canceledLogin: break
                    default: fatalError()
                    }
                    return
                }
                self?.authManager.receivedCodeRedirect(url: callbackUrl)
            })
            self.authSession?.start()
        }
        return .empty()
    }

}

extension LoginViewModel: UnsplashSessionListener {

    func didReceiveRedirect(code: String) {
        loginStateProperty.onNext(.tokenIsFetched)
        buttonNameProperty.onNext("Please wait ...")
        self.authManager.accessToken(with: code) { [unowned self] _, error in
            if let error = error {
                self.alertAction.execute(error.localizedDescription)
            } else {
                self.navigateToTabBarAction.execute(())
            }
        }
    }

}
