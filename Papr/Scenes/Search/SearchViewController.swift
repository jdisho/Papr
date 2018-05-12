//  
//  SearchViewController.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: UIViewController, BindableType {

    typealias SearchSectionModel = SectionModel<String, SearchResultCellModelType>

    // MARK: ViewModel
    var viewModel: SearchViewModelType!

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Private
    private var searchBar: UISearchBar!
    private var dataSource: RxTableViewSectionedReloadDataSource<SearchSectionModel>!
    private let disposeBag = DisposeBag()

    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()
        configureTableView()
    }

    // MARK: BindableType

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        searchBar.rx.text
            .filter { ($0 ?? "").count > 0 }
            .bind(to: inputs.searchString)
            .disposed(by: disposeBag)

        searchBar.rx.text
            .unwrap()
            .map { $0.count == 0 }
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)

        outputs.searchResultCellModel
            .map { [SearchSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: inputs.searchTrigger)
            .disposed(by: disposeBag)

    }

    // MARK: UI

    private func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Unsplash"
        navigationItem.titleView = searchBar

    }

    private func configureTableView() {
        tableView.tableFooterView =  UIView()
        tableView.rowHeight = 56
        tableView.registerCell(type: SearchResultCell.self)
        dataSource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(
            configureCell:  tableViewDataSource
        )
    }

    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<SearchSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueResuableCell(
                type: SearchResultCell.self,
                forIndexPath: indexPath)
            cell.bind(to: cellModel)

            return cell
        }
    }
  
}
