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

class HomeViewCell: UICollectionViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

    // MARK: ViewModel
    var viewModel: HomeViewCellModelType!

    // MARK: IBOutlets
    @IBOutlet private var headerView: HomeViewCellHeader!
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var photoButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var footerView: HomeViewCellFooter!
    
    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()

        photoButton.isExclusiveTouch = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
        photoButton.rx.action = nil

        disposeBag = DisposeBag()
    }

    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = HomeViewCell.self

        headerView.bind(to: outputs.headerViewModelType)

        outputs.photoStream
            .map { $0.id }
            .unwrap()
            .bind(to: photoImageView.rx.heroId)
            .disposed(by: disposeBag)

        outputs.photoStream
            .bind { [weak self] in
                self?.photoButton.rx.bind(to: inputs.photoDetailsAction, input: $0)
            }
            .disposed(by: disposeBag)


        Observable.combineLatest(
            outputs.smallPhoto,
            outputs.regularPhoto,
            outputs.fullPhoto)
            .flatMap { small, regular, full -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)!).asObservable(),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular)!).asObservable(),
                    this.imagePipeline.rx.loadImage(with: URL(string: full)!).asObservable()
                )
            }
            .map { $0.image }
            .execute { [unowned self] _ in
                self.activityIndicator.stopAnimating()
            }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
