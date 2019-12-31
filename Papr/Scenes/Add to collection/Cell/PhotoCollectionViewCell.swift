//
//  PhotoCollectionViewCell.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Action
import Nuke
import RxNuke

class PhotoCollectionViewCell: UICollectionViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

    // MARK: ViewModel
    var viewModel: PhotoCollectionCellModelType!

    // MARK: IBOutlets
    @IBOutlet var collectionTitle: UILabel!
    @IBOutlet var collectionCoverImageView: UIImageView!
    @IBOutlet var addToCollectionButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        addToCollectionButton.isExclusiveTouch = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        collectionCoverImageView.image = #imageLiteral(resourceName: "unsplash-icon-placeholder")
        addToCollectionButton.rx.action = nil

        disposeBag = DisposeBag()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionCoverImageView.roundCorners(withRadius: Papr.Appearance.Style.imageCornersRadius)
        addToCollectionButton.roundCorners(withRadius: Papr.Appearance.Style.imageCornersRadius)
    }
    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = PhotoCollectionViewCell.self

        outputs.isPhotoInCollection
            .subscribe { result in
                guard let isPart = result.element else { return }
                self.addToCollectionButton.rx.action = isPart ? inputs.removeAction :
                                                                   inputs.addAction
            }
            .disposed(by: disposeBag)
        
        outputs.coverPhotoURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .orEmpty()
            .map { $0.image }
            .execute { [unowned self] _ in
                self.activityIndicator.stopAnimating()
            }
            .bind(to: collectionCoverImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.collectionName
            .bind(to: collectionTitle.rx.text)
            .disposed(by: disposeBag)

        outputs.isPhotoInCollection
            .map { $0 ? .black : .clear }
            .bind(to: addToCollectionButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        outputs.isPhotoInCollection.map { $0 ? 0.6 : 1.0 }
            .bind(to: addToCollectionButton.rx.alpha)
            .disposed(by: disposeBag)

        outputs.isPhotoInCollection.map { $0 ? Papr.Appearance.Icon.doneWhiteSmall : nil }
            .bind(to: addToCollectionButton.rx.image())
            .disposed(by: disposeBag)

    }

}
