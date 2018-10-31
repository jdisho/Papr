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

class CollectionCell: UICollectionViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

    // MARK: ViewModel
    var viewModel: CollectionCellViewModelType!

    // MARK: IBOutlets

    @IBOutlet var photoCollectionImagePreview: UIImageView!
    @IBOutlet var photoCollectionTitleLabel: UILabel!
    @IBOutlet var photoCollectionAuthorLabel: UILabel!

    // MARK: Privates
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        photoCollectionImagePreview.cornerRadius = 10.0
        photoCollectionImagePreview.dim(withAlpha: 0.5)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
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

        let title = output.photoCollection
            .map { $0.title }
            .unwrap()

        let username = output.photoCollection
            .map { ($0.user?.firstName ?? "") + " " + ($0.user?.lastName ?? "") }

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

        title
            .bind(to: photoCollectionTitleLabel.rx.text)
            .disposed(by: disposeBag)

        username
            .bind(to: photoCollectionAuthorLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
