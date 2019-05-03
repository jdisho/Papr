//
//  UserProfileViewController.swift
//  Papr
//
//  Created by Joan Disho on 09.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift

class UserProfileViewController: UIViewController, BindableType {

    @IBOutlet weak var logoutButton: UIButton!
    
    var viewModel: UserProfileViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        
        logoutButton.rx.action = inputs.logoutAction
    }
}
