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
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        photoCollectionImagePreview.roundCorners(withRadius: 10.0)
        photoCollectionImagePreview.dim(withAlpha: 0.2)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoCollectionImagePreview.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let output = viewModel.output

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
            .bind { [weak self] collection in
                guard let `self` = self,
                    let collectionCoverColor = UIColor(hexString: collection.coverPhoto?.color ?? ""),
                    let collectionCoverColorPhotoURLString = collection.coverPhoto?.urls?.regular,
                    let collectionCoverColorPhotoURL = URL(string: collectionCoverColorPhotoURLString)
                    else { return }

                let options = ImageLoadingOptions(
                    placeholder: UIImage.fromColor(collectionCoverColor),
                    transition: .fadeIn(duration: 0.5, options: .curveEaseInOut),
                    failureImage: nil,
                    failureImageTransition: nil,
                    contentModes: ImageLoadingOptions.ContentModes(
                        success: .scaleAspectFill,
                        failure: .scaleAspectFill,
                        placeholder: .scaleAspectFill
                    )
                )

                Nuke.loadImage(
                    with: collectionCoverColorPhotoURL,
                    options: options,
                    into: self.photoCollectionImagePreview,
                    progress: nil,
                    completion: nil
                )
            }
            .disposed(by: disposeBag)
    }
}
