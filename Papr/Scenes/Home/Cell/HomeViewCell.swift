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
import RxNuke
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

        userImageView.roundCorners(withRadius: userImageView.frame.height / 2)
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
            .map { $0.id }
            .unwrap()
            .bind(to: photoImageView.rx.heroId)
            .disposed(by: disposeBag)

        Observable.combineLatest(outputs.likedByUser, outputs.photoStream)
            .bind { [weak self] in
                self?.likeButton.rx.bind(to: $0 ? inputs.unlikePhotoAction: inputs.likePhotoAction, input: $1)
            }
            .disposed(by: disposeBag)

        outputs.photoStream
            .bind { [weak self] in
                self?.photoButton.rx.bind(to: inputs.photoDetailsAction, input: $0)
                self?.collectPhotoButton.rx.bind(to: inputs.userCollectionsAction, input: $0)
            }
            .disposed(by: disposeBag)

        outputs.userProfileImage
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.photoStream
            .flatMapIgnore { [weak self] _ in
               Observable.just(self?.activityIndicator.stopAnimating())
             }
            .bind { [weak self] photo in
                guard let `self` = self,
                    let photoURLString = photo.urls?.regular,
                    let url = URL(string: photoURLString),
                    let color = UIColor(hexString: photo.color ?? "")
                    else { return }

                let options = ImageLoadingOptions(
                    placeholder: UIImage.fromColor(color),
                    transition: .fadeIn(duration: 0.5, options: .curveEaseInOut),
                    failureImage: nil,
                    failureImageTransition: nil,
                    contentModes: ImageLoadingOptions.ContentModes(
                        success: .scaleAspectFit,
                        failure: .scaleAspectFill,
                        placeholder: .scaleAspectFill
                    )
                )

                Nuke.loadImage(
                    with: url,
                    options: options,
                    into: self.photoImageView,
                    progress: nil,
                    completion: nil
                )
            }
            .disposed(by: disposeBag)

        outputs.fullname
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.username
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.photoSize
            .map { CGFloat($1 * Int(UIScreen.main.bounds.width) / $0) }
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
            .bind { [weak self] in
                self?.downloadPhotoButton.rx.bind(to: inputs.downloadPhotoAction, input: $0)
            }
            .disposed(by: disposeBag)


        inputs.downloadPhotoAction.elements
            .bind { [weak self] linkString in
                guard let `self` = self,
                    let url = URL(string: linkString) else { return }

                Nuke.loadImage(with: url, into: self.dummyImageView) { response, _ in
                    guard let image = response?.image else { return }
                    inputs.writeImageToPhotosAlbumAction.execute(image)
                }
            }
            .disposed(by: disposeBag)
    }
}
