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

class HomeViewCell: UICollectionViewCell, BindableType {

    // MARK: ViewModel

    var viewModel: HomeViewCellModel!

    // MARK: IBOutlets

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameButton: UIButton!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var photoWidthConstraint: NSLayoutConstraint!
    @IBOutlet var circularLoaderContainerView: UIView!
    @IBOutlet var postedTimeLabel: UILabel!
    
    // MARK: Private
    private let nukeManager = Nuke.Manager.shared
    private var disposeBag = DisposeBag()
    private var cirularLoaderShapeLayer = CAShapeLayer()

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.rounded
        circularLoaderContainerView.layer.addSublayer(circularLoader)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        photoWidthConstraint.constant = UIScreen.main.bounds.width
    }

    override func prepareForReuse() {
        userImageView.image = nil
        photoImageView.image = nil
        downloadProgress = 0
        disposeBag = DisposeBag()
    }

    // MARK: BindableType

    func bindViewModel() {
        guard let smallPhotoURL = URL(string: viewModel.smallPhoto.value), 
            let regularPhotoURL = URL(string: viewModel.regularPhoto.value) else { return }
        
        var regularPhotoRequest = Request(url: regularPhotoURL)

        regularPhotoRequest.progress = { completed, total in
            let completed = Double(completed)
            let total = Double(total)
            self.downloadProgress = completed / total
        }

        nukeManager.loadImage(with: viewModel.userProfileImage.value)
            .orEmpty
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)

        Observable.concat(nukeManager.loadImage(with: smallPhotoURL).orEmpty,
                          nukeManager.loadImage(with: regularPhotoRequest).orEmpty)
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.fullname
            .asObservable()
            .bind(to: usernameButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.photoSizeCoef
            .asObservable()
            .map { CGFloat($0) }
            .bind(to: photoHeightConstraint.rx.constant)
            .disposed(by: disposeBag)

        viewModel.created
            .asObservable()
            .bind(to: postedTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: UI

    private var circularLoader: CAShapeLayer {
        let containerWidth = circularLoaderContainerView.frame.width
        let containerHeight = circularLoaderContainerView.frame.height
        let arcCenter = CGPoint (x:  containerWidth / 2, y: containerHeight / 2)
        let radius = containerWidth / 2
        let startAngle = CGFloat(-0.5 * Double.pi)
        let endAngle = CGFloat(1.5 * Double.pi)
        let circlePath = UIBezierPath(arcCenter: arcCenter,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)

        cirularLoaderShapeLayer.path = circlePath.cgPath
        cirularLoaderShapeLayer.strokeColor = UIColor.gray.cgColor
        cirularLoaderShapeLayer.fillColor = UIColor.clear.cgColor
        cirularLoaderShapeLayer.lineWidth = 2
        
        return cirularLoaderShapeLayer
    }

    private var downloadProgress: Double {
        get {
            return Double(circularLoader.strokeEnd)
        }
        set {
            if newValue >= 1 || newValue <= 0{
                circularLoader.strokeEnd = 0
                circularLoader.isHidden = true
            } else {
                circularLoader.isHidden = false
                circularLoader.strokeEnd = CGFloat(newValue)
            }
        }
    }
}
