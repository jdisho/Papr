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

class PhotoCollectionViewCell: UICollectionViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: PhotoCollectionCellModelType!

    // MARK: IBOutlets
    @IBOutlet var collectionTitle: UILabel!
    @IBOutlet var collectionCoverImageView: UIImageView!
//    @IBOutlet var isPrivateIconImageView: UIImageView!

    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionCoverImageView.rounded(withRadius: 10)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        collectionCoverImageView.image = #imageLiteral(resourceName: "unsplash-icon-placeholder")
        disposeBag = DisposeBag()
    }

    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        outputs.coverPhotoURL
            .flatMap { PhotoCollectionViewCell.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: collectionCoverImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.collectionName
            .bind(to: collectionTitle.rx.text)
            .disposed(by: disposeBag)


    }

}
