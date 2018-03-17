//
//  PhotoDetailsViewController.swift
//  Papr
//
//  Created by Joan Disho on 03.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import Nuke
import RxSwift

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
    @IBOutlet var dismissButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var statsContainerViewBottomConstraint: NSLayoutConstraint!

    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared
    private let disposeBag = DisposeBag()
    private var isTouched = true

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        showHideOverlays(withDelay: 1.0)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

     // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = PhotoDetailsViewController.self

        dismissButton.rx.action = inputs.dismissAction

        outputs.regularPhoto
            .flatMap { this.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.photoSizeCoef
            .map { CGFloat($0) }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: disposeBag)

        outputs.likedByUser
            .map { $0 ? #imageLiteral(resourceName: "favorite-white") : #imageLiteral(resourceName: "favorite-border-white") }
            .bind(to: likeButton.rx.image())
            .disposed(by: disposeBag)

        outputs.totalViews
            .bind(to: totalViewsLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.totalLikes
            .bind(to: totalLikesLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.totalDownloads
            .bind(to: totalDownloadsLabel.rx.text)
            .disposed(by: disposeBag)

        Observable.combineLatest(outputs.likedByUser, outputs.photoStream)
            .subscribe { result in
                guard let result = result.element else { return }
                let (likedByUser, photo) = result
                if likedByUser {
                    self.likeButton.rx
                        .bind(to: inputs.unlikePhotoAction, input: photo)
                } else {
                    self.likeButton.rx
                        .bind(to: inputs.likePhotoAction, input: photo)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showHideOverlays))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc private func showHideOverlays(withDelay delay: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.5,
                           animations: {
                if self.isTouched {
                    self.statsContainerViewBottomConstraint.constant = 0
                    self.dismissButtonTopConstraint.constant = 32
                    self.isTouched = false
                } else {
                    self.statsContainerViewBottomConstraint.constant = 132
                    self.dismissButtonTopConstraint.constant = -100
                    self.isTouched = true
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}
