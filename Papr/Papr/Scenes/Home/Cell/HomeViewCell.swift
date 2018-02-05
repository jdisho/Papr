//
//  HomeViewCell.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class HomeViewCell: UITableViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: HomeViewCellModel!

    // MARK: IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameButton: UIButton!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoHeightConstraint: NSLayoutConstraint!

    // MARK: Private
    private let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides
    override func awakeFromNib() {
        self.userImageView.rounded
    }

    override func prepareForReuse() {
        userImageView.image = nil
        photoImageView.image = nil
        disposeBag = DisposeBag()
    }

    // MARK: BindableType
    func bindViewModel() {

        nukeManager.loadImage(with: viewModel.userProfileImage)
            .asObservable()
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)
        
        Observable.concat(nukeManager.loadImage(with: viewModel.smallPhoto).asObservable(),
                          nukeManager.loadImage(with: viewModel.regularPhoto).asObservable())
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)

        Observable.just(viewModel.fullname)
            .bind(to: usernameButton.rx.title())
            .disposed(by: disposeBag)

        Observable.just(viewModel.photoSize)
            .map { width, height in
                CGFloat(height) * UIScreen.main.bounds.width / CGFloat(width)
            }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: disposeBag)
    }
}
