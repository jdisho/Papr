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
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var totalViewsLabel: UILabel!
    @IBOutlet var totalLikesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var totalDownloadsLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var moreButton: UIButton!

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

        dismissButton.rx.action = inputs.dismissAction

        outputs.photo
            .flatMap { this.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: photoImageView.rx.image)
            .disposed(by: rx.disposeBag)

        outputs.photoSizeCoef
            .map { CGFloat($0) }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: rx.disposeBag)

        outputs.totalViews
            .map { "\($0)" }
            .bind(to: totalViewsLabel.rx.text)
            .disposed(by: rx.disposeBag)

        outputs.totalLikes
            .map { "\($0)" }
            .bind(to: totalLikesLabel.rx.text)
            .disposed(by: rx.disposeBag)

        outputs.totalDownloads
            .map { "\($0)" }
            .bind(to: totalDownloadsLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}
