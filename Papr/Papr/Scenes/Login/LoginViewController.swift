//
//  Login.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import Moya
import SafariServices
import RxSwift
import KeychainSwift

class LoginViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: LoginViewModel!

    // MARK: IBOutlets
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeychainSwift().clear()
        print("LoginViewController")
    }

    func bindViewModel() {
        loginButton.rx.action = viewModel.loginAction
        
        viewModel.buttonName
            .asObservable()
            .bind(to: loginButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.loginState
            .asObservable()
            .map { $0 == .idle }
            .bind(to: activityIndicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.loginState
            .asObservable()
            .map { $0 == .idle }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }

}
