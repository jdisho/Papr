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
        let inputs = viewModel.input
        let outputs = viewModel.output

        outputs.navTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)

        outputs.usersViewModel
            .map { [SearchUsersSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.contentOffset
            .map { [unowned self] _ in
                return self.tableView.isNearTheBottomEdge()
            }
            .distinctUntilChanged()
            .bind(to: inputs.loadMore)
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
