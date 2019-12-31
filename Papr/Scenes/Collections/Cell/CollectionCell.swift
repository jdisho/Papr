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
        photoCollectionImagePreview.roundCorners(withRadius: Papr
            .Appearance.Style.imageCornersRadius)
        photoCollectionImagePreview.dim(withAlpha: 0.2)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoCollectionImagePreview.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let output = viewModel.output
        let this = CollectionCell.self

        output.photoCollection
            .map { $0.title }
            .unwrap()
            .bind(to: photoCollectionTitleLabel.rx.text)
            .disposed(by: disposeBag)

        output.photoCollection
            .map { ($0.user?.firstName ?? "") + " " + ($0.user?.lastName ?? "") }
            .bind(to: photoCollectionAuthorLabel.rx.text)
            .disposed(by: disposeBag)

        output.photoCollection
            .map { $0.coverPhoto?.color }
            .unwrap()
            .map { UIColor(hexString: $0) }
            .unwrap()
            .map { $0.toImage() }
            .unwrap()
            .bind(to: photoCollectionImagePreview.rx.image)
            .disposed(by: disposeBag)

        let smallPhotoURL = output.photoCollection
            .map { $0.coverPhoto?.urls?.small }
            .unwrap()

        let regularPhotoURL = output.photoCollection
            .map { $0.coverPhoto?.urls?.regular }
            .unwrap()

        Observable.combineLatest(smallPhotoURL, regularPhotoURL)
            .flatMap { small, regular -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)!).asObservable(),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular)!).asObservable()
                )
            }
            .orEmpty()
            .map { $0.image }
            .bind(to: photoCollectionImagePreview.rx.image)
            .disposed(by: disposeBag)
    }
}
