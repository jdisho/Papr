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
import VanillaConstraints

class SearchViewController: UIViewController, BindableType {

    typealias SearchSectionModel = SectionModel<String, SearchResultCellModelType>

    // MARK: ViewModel
    var viewModel: SearchViewModelType!

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noResultView: UIView!

    // MARK: Private
    private var searchBar: UISearchBar!
    private var dataSource: RxTableViewSectionedReloadDataSource<SearchSectionModel>!
    private let disposeBag = DisposeBag()

    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()
        configureTableView()
        configureBouncyView()
    }
    
    // MARK: Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }

    // MARK: BindableType

    func bindViewModel() {
        let inputs = viewModel.input
        let outputs = viewModel.output

        searchBar.rx.text
            .unwrap()
            .bind(to: inputs.searchString)
            .disposed(by: disposeBag)

        searchBar.rx.text
            .unwrap()
            .map { $0.count == 0 }
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)

        searchBar.rx.text
            .unwrap()
            .map { $0.count > 0 }
            .bind(to: noResultView.rx.isHidden)
            .disposed(by: disposeBag)

        outputs.searchResultCellModel
            .map { [SearchSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .flatMapIgnore { [unowned self] _ in
                Observable.just(self.searchBar.endEditing(true))
            }
            .map { $0.row }
            .bind(to: inputs.searchTrigger)
            .disposed(by: disposeBag)
    }

    // MARK: UI

    private func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search Unsplash"
        navigationItem.titleView = searchBar

        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 56
        tableView.register(cellType: SearchResultCell.self)
        dataSource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(
            configureCell:  tableViewDataSource
        )
    }

    private func configureBouncyView() {
        let bouncyView = BouncyView(frame: noResultView.frame)
        bouncyView.configure(emoji: "🏞", message: "Search Unsplash")
        bouncyView.clipsToBounds = true
        bouncyView.add(to: noResultView).pinToEdges()
    }

    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<SearchSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueResuableCell(withCellType: SearchResultCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)

            return cell
        }
    }
  
}
