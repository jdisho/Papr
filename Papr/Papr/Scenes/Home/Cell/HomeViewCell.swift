//
//  HomeViewCell.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import NSObject_Rx

class HomeViewCell: UITableViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: HomeViewCellModel!
    
    // MARK: IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameButton: UIButton!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoHeightConstraint: NSLayoutConstraint!
    
    // MARK: BindableType
    func bindViewModel() {
        
        viewModel.userPicImageURLString
            .mapResource
            .subscribe { [unowned self] imageResource in
                guard let resource = imageResource.element else { return }
                self.userImageView.kf.setImage(with: resource)
            }.disposed(by: rx.disposeBag)
        
        viewModel.fullname
            .bind(to: self.usernameButton.rx.title())
            .disposed(by: rx.disposeBag)
        
        viewModel.photoURLString
            .mapResource
            .subscribe {[unowned self] imageResource in
                guard let resource = imageResource.element else { return }
               self.photoImageView.kf.setImage(with: resource)
            }.disposed(by: rx.disposeBag)
        
        viewModel.photoSize
            .map { width, height in
                CGFloat(height) * UIScreen.main.bounds.width / CGFloat(width)
            }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: rx.disposeBag)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
