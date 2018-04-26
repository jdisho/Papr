//
//  AlertViewController.swift
//  Papr
//
//  Created by Joan Disho on 25.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift

class AlertViewController: UIAlertController, BindableType {
    
    var viewModel: AlertViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private let disposeBag = DisposeBag()
    // MARK: BindableType
    
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        outputs.title
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        outputs.message
            .bind(to: self.rx.message)
            .disposed(by: disposeBag)
        
        outputs.mode.subscribe { mode in
            guard let mode = mode.element else { return }
            switch mode {
            case .ok:
                let alertAction = UIAlertAction(
                    title: "Ok",
                    style: .cancel,
                    handler: { _ in  inputs.closeAction.execute(()) })
                self.addAction(alertAction)
            case .yesNo:
                let yesAction = UIAlertAction(
                    title: "Yes",
                    style: .default,
                    handler: { _ in inputs.yesAction.execute(())})
                self.addAction(yesAction)
                
                let noAction = UIAlertAction(
                    title: "No",
                    style: .cancel,
                    handler: { _ in inputs.noAction.execute(())})
                self.addAction(noAction)
            }
        }
        .disposed(by: disposeBag)
        
    }
}
