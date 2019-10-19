//
//  LoadingButton.swift
//  Papr
//
//  Created by Piotr on 19/10/2019.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    private var originalImage: UIImage?
    
    var isLoading: Bool = false {
        didSet {
            isEnabled = !isLoading
            if isLoading {
                originalImage = image(for: .normal)
                setImage(nil, for: .normal)
                activityIndicator.startAnimating()
            } else {
                setImage(originalImage, for: .normal)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        if let image = image {
            originalImage = image
        }
    }

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        return activityIndicator
    }()
}
