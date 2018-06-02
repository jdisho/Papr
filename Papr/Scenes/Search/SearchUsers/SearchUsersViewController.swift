//  
//  SearchUsersViewController.swift
//  Papr
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchUsersViewController: UIViewController, BindableType {

    typealias SearchUsersSectionModel = SectionModel<String, UserCellModelType>

    // MARK: ViewModel
    var viewModel: SearchUsersViewModel!

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Private
    private var dataSource: RxTableViewSectionedReloadDataSource<SearchUsersSectionModel>!
    private let disposeBag = DisposeBag()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    // MARK: - BindableType

    func bindViewModel() {
        let outputs = viewModel.output

        Observable.zip(outputs.searchQuery, outputs.totalResults)
            .map { query, resultsNumber in
                return "\(query): \(resultsNumber) results"
            }
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)

        outputs.usersViewModel
            .map { [SearchUsersSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureTableView() {
        tableView.registerCell(type: UserCell.self)
        tableView.rowHeight = 60
        dataSource = RxTableViewSectionedReloadDataSource<SearchUsersSectionModel>(
            configureCell:  tableViewDataSource
        )
    }

    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<SearchUsersSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueResuableCell(
                type: UserCell.self,
                forIndexPath: indexPath)
            cell.bind(to: cellModel)

            return cell
        }
    }
}
