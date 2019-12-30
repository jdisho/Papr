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

class HomeViewCellHeader: UIView, BindableType {

    var viewModel: HomeViewCellHeaderModelType! {
        didSet {
            configureUI()
        }
    }

    private lazy var profileImageView = UIImageView()
    private lazy var stackView = UIStackView()

    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        return label
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private lazy var updatedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()

    func bindViewModel() {
        let outputs = viewModel.outputs
        let this = HomeViewCellHeader.self

        outputs.profileImageURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .orEmpty()
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
        profileImageView.roundCorners(withRadius: Papr.Appearance.Style.imageCornersRadius)

        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.distribution = .fill
        stackView.alignment = .fill

        stackView.addArrangedSubview(fullNameLabel)
        stackView.addArrangedSubview(userNameLabel)

        profileImageView.add(to: self)
            .left(to: \.leftAnchor, constant: 16.0)
            .centerY(to: \.centerYAnchor)
            .size(CGSize(width: 48.0, height: 48.0))

        stackView.add(to: self)
            .left(to: \.rightAnchor, of: profileImageView, constant: 16.0)
            .centerY(to: \.centerYAnchor)

        updatedTimeLabel.add(to: self)
            .right(to: \.rightAnchor, constant: 16.0)
            .centerY(to: \.centerYAnchor)
            .left(to: \.rightAnchor, of: stackView, constant: 8.0)
    }
}
