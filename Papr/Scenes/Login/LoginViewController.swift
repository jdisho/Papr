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
import RxNuke

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
        loginButton.roundCorners(withRadius: Papr.Appearance.Style.imageCornersRadius)
        imageView.dim(withAlpha: 0.1)
        imageView.image = nil
        imageView.image = UIImage(named: "placeholder_wallpaper")
        closeButton.setImage(Papr.Appearance.Icon.close, for: .normal)
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
            .map { $0 == .idle ? 1.0 : 0.9 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        outputs.randomPhotos
            .map { $0.compactMap { $0.urls?.regular } }
            .mapMany {
                this.imagePipeline.rx.loadImage(with: URL(string: $0)!).asObservable().orEmpty()
        }
            .mapMany { $0.map { $0.image } }
            .flatMap(Observable.combineLatest)
            .map { UIImage.animatedImage(with: $0, duration: 60.0) }
            .unwrap()
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

}
