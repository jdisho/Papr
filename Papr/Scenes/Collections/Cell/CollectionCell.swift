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

    // MARK: Privates
    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        photoCollectionImagePreview.cornerRadius = 10.0
        userProfilePic.cornerRadius = Double(userProfilePic.frame.height / 2)
    }

    override func prepareForReuse() {
        userProfilePic.image = nil
        photoCollectionImagePreview.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let output = viewModel.output
        let this = CollectionCell.self

        Observable.combineLatest(output.smallPhotoURL, output.regularPhotoURL)
            .flatMap { small, regular -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular))
                )
            }
            .map { $0.image }
            .bind(to: photoCollectionImagePreview.rx.image)
            .disposed(by: disposeBag)

        Observable.combineLatest(output.mediumUserProfilePic, output.largeUserProfilePic)
            .flatMap { medium, large -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: medium)),
                    this.imagePipeline.rx.loadImage(with: URL(string: large))
                )
            }
            .map { $0.image }
            .bind(to: userProfilePic.rx.image)
            .disposed(by: disposeBag)

        output.title
            .bind(to: photoCollectionTitleLabel.rx.text)
            .disposed(by: disposeBag)

        output.username
            .bind(to: photoCollectionAuthorLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
