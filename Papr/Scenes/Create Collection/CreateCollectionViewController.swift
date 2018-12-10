//
//  CreateCollectionViewController.swift
//  Papr
//
//  Created by Joan Disho on 29.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateCollectionViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: CreateCollectionViewModelType!

    // MARK: IBOutlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var privateSwitch: UISwitch!

    // MARK: Private
    private let disposeBag = DisposeBag()
    private var cancelBarButton: UIBarButtonItem!
    private var saveBarButton: UIBarButtonItem!
    private var activityIndicatorBarButton: UIBarButtonItem!
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.becomeFirstResponder()
        configureNavigationBar()
    }

    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        nameTextField.rx.text.orEmpty
            .bind(to: inputs.collectionName)
            .disposed(by: disposeBag)

        descriptionTextField.rx.text.orEmpty
            .bind(to: inputs.collectionDescription)
            .disposed(by: disposeBag)

        privateSwitch.rx.isOn
            .bind(to: inputs.isPrivate)
            .disposed(by: disposeBag)

        outputs.saveButtonEnabled
            .bind(to: saveBarButton.rx.isEnabled)
            .disposed(by: disposeBag)

        inputs.saveAction.executing
            .subscribe { [unowned self] result in
                guard let isExecuting = result.element else { return }
                if isExecuting {
                    self.navigationItem.rightBarButtonItem = self.activityIndicatorBarButton
                }
            }.disposed(by: disposeBag)


        cancelBarButton.rx.action = inputs.cancelAction
        saveBarButton.rx.action = inputs.saveAction
    }

    // MARK: UI
    private func configureNavigationBar() {
        title = "New collection"

        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()

        activityIndicatorBarButton = UIBarButtonItem(customView: activityIndicator)

        cancelBarButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: nil
        )
        saveBarButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: nil
        )

        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        navigationController?.navigationBar.tintColor = .black
    }

}
