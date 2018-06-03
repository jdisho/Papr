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

class UserCell: UITableViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: UserCellModelType!

    // MARK: IBOutlets
    @IBOutlet var profilePhotoImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!

    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides

    override func awakeFromNib() {
        profilePhotoImageView.cornerRadius = 5
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
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.profilePhotoURL
            .flatMap { this.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: profilePhotoImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
