//
//  SearchPhotosViewController.swift
//  Papr
//
//  Created by Joan Disho on 26.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchPhotosViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: SearchPhotosViewModelType!

    // MARK: IBOutlets
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        
    }
}

