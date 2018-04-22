//
//  AddToCollectionViewController.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

class AddToCollectionViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: AddToCollectionViewModel!

    // MARK: IBOutlets
    @IBOutlet var addToCollectionButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var transparentViewContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.animate(withDuration: 0.5, animations: {
                self.transparentViewContainer.backgroundColor = .black
                self.transparentViewContainer.alpha = 0.2
            })
        }
    }

    func bindViewModel() {

    }
}
