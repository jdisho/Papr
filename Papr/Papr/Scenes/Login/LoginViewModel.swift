//
//  Login.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import SafariServices
import Moya

enum LoginState {
    case idle
    case fetchingToken
    case tokenIsFetched
}

protocol LoginViewModelInput {
    var loginAction: CocoaAction { get }
}

protocol LoginViewModelOuput {
    var buttonName: BehaviorRelay<String>! { get }
    var loginState: BehaviorRelay<LoginState>! { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOuput { get }
}

class LoginViewModel: LoginViewModelInput, LoginViewModelOuput, LoginViewModelType   {

    // MARK: Inputs & Outputs
    var inputs: LoginViewModelInput { return self }
    var outputs: LoginViewModelOuput { return self }
  
    // MARK: Output
    var buttonName: BehaviorRelay<String>!
    var loginState: BehaviorRelay<LoginState>!
    
    // MARK: Private
    fileprivate let authManager: UnsplashAuthManager 
    private let sceneCoordinator: SceneCoordinatorType
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
    
    // MARK: Init
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, 
         authManager: UnsplashAuthManager = UnsplashAuthManager.sharedAuthManager) {
        self.sceneCoordinator = sceneCoordinator
        self.moyaProvider = MoyaProvider<UnsplashAPI>()
        self.authManager = authManager
        self.authManager.delegate = self
        
        loginState = BehaviorRelay(value: .idle)
        buttonName = BehaviorRelay(value: "Login with Unsplash")
    }

    // MARK: Action
    lazy var loginAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in 
            self.authenticate()
        }
    }()
    
    private lazy var navigateToHomeAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in 
            let viewModel = HomeViewModel()
            return self.finishLogin()
                .ignoreAll()
                .flatMap { _ in
                    self.sceneCoordinator.transition(to: .home(viewModel), type: .root)
                }
        }
    }()
    
    private func authenticate() -> Observable<Void> {        
        if #available(iOS 11.0, *) {
            self.authSession = SFAuthenticationSession(url: authManager.authURL, 
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
    
    @discardableResult
    private func finishLogin() -> Observable<User?> {
       loginState.accept(.fetchingToken)
        return moyaProvider.rx
            .request(.getMe)
            .asObservable()
            .mapOptional(User.self)
    }
}

extension LoginViewModel: UnsplashSessionListener {

    func didReceiveRedirect(code: String) {
        loginState.accept(.tokenIsFetched)
        buttonName.accept("Please wait ...")
        self.authManager.accessToken(with: code) { [unowned self] _,_ in 
            self.navigateToHomeAction.execute(())
        }
    }

}
