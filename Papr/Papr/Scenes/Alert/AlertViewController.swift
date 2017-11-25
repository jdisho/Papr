//
//  AlertViewController.swift
//  Papr
//
//  Created by Joan Disho on 25.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlertViewController: UIAlertController, BindableType {
    
    // MARK: ViewModel
    var viewModel: AlertViewModel!
    
    // MARK: Private
    private var cancelAction: UIAlertAction!
    private var yesAction: UIAlertAction!
    private var noAction: UIAlertAction!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    // MARK: BindableType
    func bindViewModel() {

        viewModel.title
            .asObservable()
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.message
            .asObservable()
            .bind(to: self.rx.message)
            .disposed(by: disposeBag)
        
        switch viewModel.mode.value {
        case .cancel:
            cancelAction.rx.action = viewModel.cancelAction
            addAction(cancelAction)
        case .yesOrNo:
            yesAction.rx.action = viewModel.yesAction
            noAction.rx.action = viewModel.noAction
            addAction(yesAction)
            addAction(noAction)
        }
    }
    
    // MARK: UI
    private func configureUI() {
        cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        yesAction = UIAlertAction(title: "Yes", style: .default)
        noAction = UIAlertAction(title: "No", style: .cancel)
    }


}
