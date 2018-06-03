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
    @IBOutlet var followButton: UIButton!

    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides

    override func awakeFromNib() {
        profilePhotoImageView.cornerRadius = 5
        followButton.cornerRadius = 5
        followButton.borderWidth = 1
        followButton.borderColor = UIColor(hexString: "5096E8")?.cgColor
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

        // TODO: Change followButton color
    }
}
