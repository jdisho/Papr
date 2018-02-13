//
//  Login.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class LoginViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: LoginViewModelType!

    // MARK: IBOutlets
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        loginButton.rx.action = viewModel.inputs.loginAction

        viewModel.outputs.buttonName
            .bind(to: loginButton.rx.title())
            .disposed(by: rx.disposeBag)

        viewModel.outputs.loginState
            .map { $0 == .idle }
            .bind(to: activityIndicatorView.rx.isHidden)
            .disposed(by: rx.disposeBag)

        viewModel.outputs.loginState
            .map { $0 == .idle }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        viewModel.outputs.loginState
            .map { $0 == .idle ? 1.0 : 0.7 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: rx.disposeBag)
    }

}
