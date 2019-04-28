//
//  HomeViewCellFooter.swift
//  Papr
//
//  Created by Joan Disho on 27.04.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import UIKit
import VanillaConstraints
import RxSwift
import Nuke

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

        stackView.addArrangedSubview(leftViewContainer)
        stackView.addArrangedSubview(rightViewContainer)

        return stackView
    }()

    private lazy var leftViewContainer: UIView = {
        let view = UIView()

        likeButton.add(to: view)
            .left(to: \.leftAnchor, constant: 16.0)
            .centerY(to: \.centerYAnchor)
            .size(CGSize(width: 32.0, height: 32.0))

        likesNumberLabel.add(to: view)
            .left(to: \.rightAnchor, of: likeButton, constant: 16.0)
            .centerY(to: \.centerYAnchor)

        return view
    }()

    private lazy var rightViewContainer: UIView = {
        let view = UIView()

        saveButton.add(to: view)
            .right(to: \.rightAnchor, constant: 16.0)
            .centerY(to: \.centerYAnchor)
            .size(CGSize(width: 32.0, height: 32.0))

        downloadButton.add(to: view)
            .right(to: \.leftAnchor, of: saveButton, constant: 16.0)
            .centerY(to: \.centerYAnchor)
            .size(CGSize(width: 32.0, height: 32.0))

        return view
    }()

    private lazy var likeButton = UIButton()
    private lazy var likesNumberLabel = UILabel()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "bookmark-border-black"), for: .normal)
        return button
    }()

    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "down-black"), for: .normal)
        return button
    }()


    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        inputs.downloadPhotoAction.elements
            .subscribe { [unowned self] result in
                guard let linkString = result.element,
                    let url = URL(string: linkString) else { return }

                Nuke.loadImage(with: url, into: self.dummyImageView) { response, _ in
                    guard let image = response?.image else { return }
                    inputs.writeImageToPhotosAlbumAction.execute(image)
                }
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(outputs.isLikedByUser, outputs.photo)
            .bind { [weak self] in
                self?.likeButton.rx.bind(to: $0 ? inputs.unlikePhotoAction: inputs.likePhotoAction, input: $1)
            }
            .disposed(by: disposeBag)

        outputs.photo
            .bind { [weak self] in
                self?.saveButton.rx.bind(to: inputs.userCollectionsAction, input: $0)
            }
            .disposed(by: disposeBag)

        outputs.photo
            .bind { [weak self] in
                self?.downloadButton.rx.bind(to: inputs.downloadPhotoAction, input: $0)
            }
            .disposed(by: disposeBag)

        outputs.likesNumber
            .bind(to: likesNumberLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.isLikedByUser
            .map { $0 ? #imageLiteral(resourceName: "favorite-black") : #imageLiteral(resourceName: "favorite-border-black") }
            .bind(to: likeButton.rx.image())
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        stackViewContainer.add(to: self).pinToEdges()
    }
}
