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
import VanillaConstraints

class CollectionCell: UICollectionViewCell, BindableType, ClassIdentifiable {

    var viewModel: CollectionCellViewModelType!
    private let titleLabel = UILabel()

    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bindViewModel() {
        viewModel.output.photoCollection
            .map { $0.title }
            .unwrap()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

         configureUI()

    }

    private func configureUI() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.groupTableViewBackground.cgColor
        layer.cornerRadius = Constants.Appearance.Style.imageCornersRadius
        backgroundColor = .white

        titleLabel.add(to: contentView)
            .top(to: \.topAnchor, constant: 8.0)
            .right(to: \.rightAnchor, constant: 16.0)
            .bottom(to: \.bottomAnchor, constant: 8.0)
            .left(to: \.leftAnchor, constant: 16.0)
    }
}
