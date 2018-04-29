//
//  CreateCollectionViewController.swift
//  Papr
//
//  Created by Joan Disho on 29.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift

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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    // MARK: BindableType
    func bindViewModel() {
    }

    // MARK: UI
    private func configureNavigationBar() {
        title = "New collection"
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
