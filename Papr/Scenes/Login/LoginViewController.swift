//
//  Login.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: LoginViewModelType!

    // MARK: IBOutlets
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    // MARK: Private
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.rounded(withRadius: 10)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        loginButton.rx.action = inputs.loginAction
        closeButton.rx.action = inputs.closeAction

        outputs.buttonName
            .bind(to: loginButton.rx.title())
            .disposed(by: disposeBag)

        outputs.loginState
            .map { $0 == .idle }
            .bind(to: activityIndicatorView.rx.isHidden)
            .disposed(by: disposeBag)

        outputs.loginState
            .map { $0 == .idle }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        outputs.loginState
            .map { $0 == .idle ? 1.0 : 0.7 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
    }

}
