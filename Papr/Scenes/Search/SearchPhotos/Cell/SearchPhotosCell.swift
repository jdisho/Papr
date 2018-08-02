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
    @IBOutlet weak var photoButton: UIButton!
    
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

        outputs.photoURL
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
        
        outputs.photoStream
            .subscribe { [unowned self] photo in
                guard let photo = photo.element else { return }
                self.photoButton.rx
                    .bind(to: inputs.photoDetailsAction, input: photo)
            }
            .disposed(by: disposeBag)
    }

}
