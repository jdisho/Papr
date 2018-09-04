//
//  CollectionsViewController.swift
//  Papr
//
//  Created by Joan Disho on 04.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import VanillaConstraints

class CollectionsViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: CollectionsViewModelType!

    // MARK: Private
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output
    }

    private func configureTableView() {
        tableView = UITableView(frame: .zero)
        tableView.add(to: view).pinToEdges()
    }
}
