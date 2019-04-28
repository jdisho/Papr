//
//  HomeViewCellFooter.swift
//  Papr
//
//  Created by Joan Disho on 27.04.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import UIKit
import VanillaConstraints

class HomeViewCellFooter: UIView, BindableType {

    var viewModel: HomeViewCellFooterModelType! {
        didSet {
            configureUI()
        }
    }

    private lazy var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0

        stackView.addArrangedSubview(leftStackView)
        stackView.addArrangedSubview(rightStackView)

        return stackView
    }()

    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0

        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(likesNumberLabel)

        return stackView
    }()

    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0

        stackView.addArrangedSubview(downloadButton)
        stackView.addArrangedSubview(saveButton)
        return stackView
    }()

    private lazy var likeButton = UIButton()
    private lazy var saveButton = UIButton()
    private lazy var downloadButton = UIButton()
    private lazy var likesNumberLabel = UILabel()

    func bindViewModel() {

    }

    private func configureUI() {
        stackViewContainer.add(to: self).pinToEdges()
    }
}
