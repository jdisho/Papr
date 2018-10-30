//
//  CollectionCell.swift
//  Papr
//
//  Created by Joan Disho on 05.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

class CollectionCell: UITableViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

    // MARK: ViewModel
    var viewModel: CollectionCellViewModelType!

    // MARK: IBOutlets

    @IBOutlet var photoCollectionImagePreview: UIImageView!
    @IBOutlet var infoViewContainer: UIView!
    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var photoCollectionTitleLabel: UILabel!
    @IBOutlet var photoCollectionAuthorLabel: UILabel!
    @IBOutlet var photosNumberLabel: UILabel!
    
    // MARK: Privates
    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        photoCollectionImagePreview.cornerRadius = 10.0
        userProfilePic.cornerRadius = Double(userProfilePic.frame.height / 2)

        infoViewContainer.cornerRadius = 10.0
        if #available(iOS 10.0, *) {
            infoViewContainer.blur(withStyle: .regular)
        } else {
            infoViewContainer.blur(withStyle: .light)
        }

        infoViewContainer.subviews
            .filter { !($0 is UIVisualEffectView) }
            .forEach { infoViewContainer.bringSubview(toFront: $0) }

        photoCollectionImagePreview.dim(withAlpha: 0.2)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userProfilePic.image = nil
        photoCollectionImagePreview.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let output = viewModel.output
        let this = CollectionCell.self


        let smallPhotoURL = output.photoCollection
            .map { $0.coverPhoto?.urls?.small }
            .unwrap()

        let regularPhotoURL = output.photoCollection
            .map { $0.coverPhoto?.urls?.regular }
            .unwrap()

        let mediumUserProfilePic = output.photoCollection
            .map { $0.user?.profileImage?.medium }
            .unwrap()

        let largeUserProfilePic = output.photoCollection
            .map { $0.user?.profileImage?.large }
            .unwrap()

        let title = output.photoCollection
            .map { $0.title }
            .unwrap()

        let username = output.photoCollection
            .map { ($0.user?.firstName ?? "") + " " + ($0.user?.lastName ?? "") }

        let photosNumber = output.photoCollection
            .map { $0.totalPhotos?.abbreviated }
            .unwrap()

        Observable.combineLatest(smallPhotoURL, regularPhotoURL)
            .flatMap { small, regular -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular))
                )
            }
            .map { $0.image }
            .bind(to: photoCollectionImagePreview.rx.image)
            .disposed(by: disposeBag)

        Observable.combineLatest(mediumUserProfilePic, largeUserProfilePic)
            .flatMap { medium, large -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: medium)),
                    this.imagePipeline.rx.loadImage(with: URL(string: large))
                )
            }
            .map { $0.image }
            .bind(to: userProfilePic.rx.image)
            .disposed(by: disposeBag)

        title
            .bind(to: photoCollectionTitleLabel.rx.text)
            .disposed(by: disposeBag)

        username
            .bind(to: photoCollectionAuthorLabel.rx.text)
            .disposed(by: disposeBag)

        photosNumber
            .bind(to: photosNumberLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
