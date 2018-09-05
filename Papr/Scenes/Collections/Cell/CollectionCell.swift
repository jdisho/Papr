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

        output.photoCollection
            .map { $0.coverPhoto?.urls?.full }
            .unwrap()
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: photoCollectionImagePreview.rx.image)
            .disposed(by: disposeBag)

        output.photoCollection
            .map { $0.user?.profileImage?.medium }
            .unwrap()
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: userProfilePic.rx.image)
            .disposed(by: disposeBag)

        output.photoCollection
            .map { $0.title }
            .unwrap()
            .bind(to: photoCollectionTitleLabel.rx.text)
            .disposed(by: disposeBag)

        output.photoCollection
            .map { $0.user?.fullName }
            .unwrap()
            .bind(to: photoCollectionAuthorLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
