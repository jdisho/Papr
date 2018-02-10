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
import Moya

enum LoginState {
    case idle
    case fetchingToken
    case tokenIsFetched
}

class LoginViewModel {

    // MARK: Input
    let loginState = Variable<LoginState>(.idle)
    let buttonName = Variable("Login with Unsplash")
    
    // MARK: Private
    fileprivate let authManager: UnsplashAuthManager 
    private let moyaProvider: MoyaProvider<UnsplashAPI>
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
    private let sceneCoordinator: SceneCoordinatorType
    
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, 
         authManager: UnsplashAuthManager = UnsplashAuthManager.sharedAuthManager) {
        self.sceneCoordinator = sceneCoordinator
        self.moyaProvider = MoyaProvider<UnsplashAPI>()
        self.authManager = authManager
        self.authManager.delegate = self
    }

    // MARK: Action
    lazy var loginAction: CocoaAction = {
        return CocoaAction { _ in 
            self.authenticate()
        }
    }()
    
    private func authenticate() -> Observable<Void> {
        if #available(iOS 11.0, *) {
            self.authSession = SFAuthenticationSession(url: authManager.authURL, callbackURLScheme: OAuth2Config.callbackURLScheme.string, completionHandler: { [weak self] (callbackUrl, error) in
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
    
    @discardableResult
    private func finishLogin() -> Observable<User> {
        loginState.value = .tokenIsFetched
        let user = moyaProvider.rx
            .request(.me)
            .asObservable()
            .map(User.self)
        
        return user
    }
}

extension LoginViewModel: UnsplashSessionListener {

    func didReceiveRedirect(code: String) {
        loginState.value = .fetchingToken
        buttonName.value = "Please wait ..."
        self.authManager.accessToken(with: code) { _,_ in self.finishLogin() }
    }

}
