//
//  UserCell.swift
//  Papr
//
//  Created by Joan Disho on 02.06.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Nuke
import RxNuke

class UserCell: UITableViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

    // MARK: ViewModel
    var viewModel: UserCellModelType!

    // MARK: IBOutlets
    @IBOutlet var profilePhotoImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!

    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides

    override func awakeFromNib() {
        profilePhotoImageView.roundCorners(withRadius: Papr.Appearance.Style.imageCornersRadius)
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        profilePhotoImageView.image = nil
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        let outputs = viewModel.outputs
        let this = UserCell.self

        outputs.fullName
            .bind(to: fullNameLabel.rx.attributedText)
            .disposed(by: disposeBag)

        outputs.profilePhotoURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .orEmpty()
            .map { $0.image }
            .bind(to: profilePhotoImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
