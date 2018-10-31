//
//  Login.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class LoginViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: LoginViewModelType!

    // MARK: IBOutlets
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!

    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.cornerRadius = 10
        imageView.dim(withAlpha: 0.3)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = LoginViewController.self

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

        Observable.combineLatest(
            outputs.randomPhoto.map { $0.urls?.small }.unwrap(),
            outputs.randomPhoto.map { $0.urls?.regular }.unwrap(),
            outputs.randomPhoto.map { $0.urls?.full }.unwrap()
            )
            .flatMap { small, regular, full -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular)),
                    this.imagePipeline.rx.loadImage(with: URL(string: full))
                )
            }
            .map { $0.image }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

}
