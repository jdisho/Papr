//
//  HomeViewCellHeader.swift
//  Papr
//
//  Created by Joan Disho on 27.04.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class HomeViewCellHeader: UIViewController, BindableType {

    var viewModel: HomeViewCellHeaderModelType!

    private let profileImageView = UIImageView()
    private let stackView = UIStackView()
    private let fullNameLabel = UILabel()
    private let userNameLabel = UILabel()
    private let updatedTimeLabel = UILabel()

    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        let outputs = viewModel.outputs
        let this = HomeViewCellHeader.self

        outputs.profileImageURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.fullName
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.userName
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.updatedTime
            .bind(to: updatedTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        profileImageView.roundCorners(withRadius: Constants.Appearance.Style.imageCornersRadius)

        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.addArrangedSubview(fullNameLabel)
        stackView.addArrangedSubview(userNameLabel)

        profileImageView.add(to: view)
            .left(to: \.leftAnchor)
            .centerY(to: \.centerYAnchor)
            .size(CGSize(width: 40.0, height: 40.0))

        updatedTimeLabel.add(to: view)
            .right(to: \.rightAnchor)
            .centerY(to: \.centerYAnchor)

        stackView.add(to: view)
            .left(to: \.leftAnchor, of: profileImageView)
            .centerY(to: \.centerYAnchor)
            .right(to: \.leftAnchor, of: updatedTimeLabel, constant: 8.0)
    }
}
