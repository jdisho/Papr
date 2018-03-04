//
//  PhotoDetailsViewController.swift
//  Papr
//
//  Created by Joan Disho on 03.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import Nuke
import NSObject_Rx

class PhotoDetailsViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: PhotoDetailsViewModelType!

    // MARK: IBOutlets
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoHeightConstraint: NSLayoutConstraint!

    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

     // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = PhotoDetailsViewController.self

        outputs.photo
            .flatMap { this.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: photoImageView.rx.image)
            .disposed(by: rx.disposeBag)

        outputs.photoSizeCoef
            .map { CGFloat($0) }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: rx.disposeBag)
    }
}
