//
//  InitialViewController.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import Moya
import SafariServices

class InitialViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: InitialViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        print("Welcome to Papr! Btw, ViewModel is binded.")
    }
    

    
    

}
