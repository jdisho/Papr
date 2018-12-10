//
//  LoadingView.swift
//  Papr
//
//  Created by Joan Disho on 18.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit
import VanillaConstraints

class LoadingView: UIView {

    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        activityIndicatorView
            .add(to: self)
            .size(CGSize(width: 30, height: 30))
            .center()

        activityIndicatorView.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
        isHidden = true
    }
}
