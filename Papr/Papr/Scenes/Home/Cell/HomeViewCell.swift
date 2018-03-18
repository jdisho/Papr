//
//  HomeViewCell.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class HomeViewCell: UITableViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: HomeViewCellModelType!

    // MARK: IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var photoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var postedTimeLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likesNumberLabel: UILabel!
    @IBOutlet var collectPhotoButton: UIButton!
    
    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        let radius = Double(self.userImageView.frame.height / 2)
        userImageView.rounded(withRadius: radius)
    }

    override func prepareForReuse() {
        userImageView.image = nil
        photoImageView.image = nil
        likeButton.rx.action = nil
        disposeBag = DisposeBag()
    }

    // MARK: BindableType

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

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

        outputs.photoStream
            .subscribe { photo in
                guard let photo = photo.element else { return }
                self.photoButton.rx
                    .bind(to: inputs.photoDetailsAction, input: photo)
            }
            .disposed(by: disposeBag)
        
        outputs.userProfileImage
            .flatMap { HomeViewCell.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)

        Observable.concat(outputs.smallPhoto, outputs.regularPhoto)
            .flatMap { HomeViewCell.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.fullname
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.username
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.photoSizeCoef
            .map { CGFloat($0) }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: disposeBag)

        outputs.updated
            .bind(to: postedTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.totalLikes
            .bind(to: likesNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.likedByUser
            .map { $0 ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "unfavorite") }
            .bind(to: likeButton.rx.image())
            .disposed(by: disposeBag)
    }
}
