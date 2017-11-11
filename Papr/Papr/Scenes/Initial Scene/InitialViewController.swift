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
    var oauth2: OAuth2CodeGrant!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMoyaProvider()
    }
    
    func bindViewModel() {
        print("Welcome to Papr! Btw, ViewModel is binded.")
    }
    
    private func configureMoyaProvider() {
        oauth2 = OAuth2CodeGrant(settings: OAuth2Config.settings.value as! OAuth2JSON)
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.authorizeContext = self

        let sessionManager = SessionManager()
        let oauthHandler = OAuth2Handler(oauth2: oauth2)
        sessionManager.adapter = oauthHandler
        sessionManager.retrier = oauthHandler
         
        provider = MoyaProvider<Unsplash>(manager: sessionManager)
    }

}
