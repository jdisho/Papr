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
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var postedTimeLabel: UILabel!
    
    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.rounded
    }

    override func prepareForReuse() {
        userImageView.image = nil
        photoImageView.image = nil
        disposeBag = DisposeBag()
    }

    // MARK: BindableType

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        outputs.userProfileImage
            .flatMap { HomeViewCell.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)
        
        Observable.concat(outputs.smallPhoto, outputs.regularPhoto)
            .flatMap { HomeViewCell.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
    

        outputs.fullname
            .asObservable()
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.username
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.photoSizeCoef
            .asObservable()
            .map { CGFloat($0) }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: disposeBag)

        outputs.created
            .asObservable()
            .bind(to: postedTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
