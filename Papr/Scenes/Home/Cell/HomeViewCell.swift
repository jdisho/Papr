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
import Photos
import Hero

class HomeViewCell: UITableViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

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
    @IBOutlet var downloadPhotoButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        userImageView.cornerRadius = Double(userImageView.frame.height / 2)
        photoButton.isExclusiveTouch = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        userImageView.image = nil
        photoImageView.image = nil
        dummyImageView.image = nil
        likeButton.rx.action = nil
        photoButton.rx.action = nil
        disposeBag = DisposeBag()
    }

    // MARK: BindableType

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = HomeViewCell.self

        outputs.photoStream
            .map { $0.id ?? "" }
            .bind(to: photoImageView.rx.heroId)
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

        outputs.photoStream
            .subscribe { [unowned self] photo in
                guard let photo = photo.element else { return }
                self.photoButton.rx
                    .bind(to: inputs.photoDetailsAction, input: photo)
                self.collectPhotoButton.rx
                    .bind(to: inputs.userCollectionsAction, input: photo)
            }
            .disposed(by: disposeBag)

        outputs.userProfileImage
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)


        Observable.combineLatest(
            outputs.smallPhoto,
            outputs.regularPhoto,
            outputs.fullPhoto
            )
            .flatMap { small, regular, full -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular)),
                    this.imagePipeline.rx.loadImage(with: URL(string: full))
                )
            }
            .map { $0.image }
            .flatMapIgnore { [unowned self] _ in
                Observable.just(self.activityIndicator.stopAnimating())
            }
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
            .map { $0 ? #imageLiteral(resourceName: "favorite-black") : #imageLiteral(resourceName: "favorite-border-black") }
            .bind(to: likeButton.rx.image())
            .disposed(by: disposeBag)

        outputs.photoStream
            .subscribe { result in
                guard let photo = result.element else { return }
                self.downloadPhotoButton.rx
                    .bind(to: inputs.downloadPhotoAction, input: photo)
            }
            .disposed(by: disposeBag)


        inputs.downloadPhotoAction.elements
            .subscribe { [unowned self] result in
                guard let linkString = result.element,
                    let url = URL(string: linkString) else { return }

                Nuke.loadImage(with: url, into: self.dummyImageView) { response, _ in
                    guard let image = response?.image else { return }
                    inputs.writeImageToPhotosAlbumAction.execute(image)
                }
            }
            .disposed(by: disposeBag)

    }
    
}
