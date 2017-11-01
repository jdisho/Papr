//
//  InitialViewController.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import p2_OAuth2

class InitialViewController: UIViewController, BindableType {
    
    var viewModel: InitialViewModel!
    var provider: MoyaProvider<Unsplash>!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        print("Welcome to Papr! Btw, ViewModel is binded.")
    }
    
}
