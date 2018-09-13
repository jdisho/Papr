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

    typealias CollectionsSectionModel = SectionModel<String, CollectionCellViewModelType>

    // MARK: ViewModel
    var viewModel: CollectionsViewModelType!

    // MARK: Private
    private var tableView: UITableView!
    private var dataSource: RxTableViewSectionedReloadDataSource<CollectionsSectionModel>!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output

        output.collectionCellsModelType
            .map { [CollectionsSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func configureTableView() {
        tableView = UITableView(frame: .zero)
        tableView.rowHeight = 400
        tableView.separatorColor = .clear
        tableView.add(to: view).pinToEdges()

        tableView.register(cellType: CollectionCell.self)
        dataSource = RxTableViewSectionedReloadDataSource<CollectionsSectionModel>(
            configureCell:  tableViewDataSource
        )
    }

    private var tableViewDataSource: TableViewSectionedDataSource<CollectionsSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueResuableCell(withCellType: CollectionCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)

            return cell
        }
    }
}
