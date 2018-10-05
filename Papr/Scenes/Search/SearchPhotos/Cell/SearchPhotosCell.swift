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

class SearchPhotosCell: UICollectionViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

    // MARK: ViewModel
    var viewModel: SearchPhotosCellModelType!

    // MARK: IBOutlets
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: Privates
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = SearchPhotosCell.self

        Observable.combineLatest(
            outputs.smallPhotoURL,
            outputs.regularPhotoURL
            )
            .flatMap { small, regular -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular))
                )
            }
            .map { $0.image }
            .flatMapIgnore { [unowned self] image -> Observable<Void> in
                inputs.updateSize(width: Double(image.size.width), height: Double(image.size.height))
                return(.just(self.activityIndicator.stopAnimating()))
            }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
    }

}
