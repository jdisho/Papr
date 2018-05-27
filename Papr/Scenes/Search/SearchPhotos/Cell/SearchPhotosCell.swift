//
//  SearchPhotosCell.swift
//  Papr
//
//  Created by Joan Disho on 27.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class SearchPhotosCell: UICollectionViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: SearchPhotosCellModelType!

    // MARK: IBOutlets
    @IBOutlet var photoImageView: UIImageView!

    // MARK: Privates
    private static let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let outputs = viewModel.outputs
        let this = SearchPhotosCell.self

        outputs.photoURL
            .flatMap { this.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
    }

}
