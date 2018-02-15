//
//  HomeViewController.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import NSObject_Rx

typealias HomeSectionModel = SectionModel<String, Photo>

class HomeViewController: UIViewController, BindableType {
    
    // MARK: ViewModel

    var viewModel: HomeViewModelType!

    // MARK: IBOutlets

    @IBOutlet var tableView: UITableView!
    
    // MARK: Private

    private var dataSource: RxTableViewSectionedReloadDataSource<HomeSectionModel>!
    private var refreshControl: UIRefreshControl!

    // MARK: Override

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationController()
        configureRefreshControl()
        configureTableView()
        refresh()
    }

    // MARK: BindableType
    
    func bindViewModel() {
        dataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell:  tableViewDataSource
        )
        
        viewModel.outputs.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        
        viewModel.outputs.photos
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        tableView.rx
            .contentOffset
            .flatMap { [unowned self] _ in 
                Observable.just(self.tableView.isNearTheBottomEdge())
            }
            .distinctUntilChanged()
            .skipUntil(viewModel.outputs.isRefreshing)
            .bind(to: viewModel.inputs.loadMore)
            .disposed(by: rx.disposeBag)
    }

    // MARK: UI
    
    private func configureNavigationController() {
        self.title = "Home 🏡"
    }
    
    private func configureTableView() {
        tableView.registerCell(type: HomeViewCell.self)
        tableView.estimatedRowHeight = 400
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh() {
        viewModel.inputs.refresh()
    }
    
    var tableViewDataSource: TableViewSectionedDataSource<HomeSectionModel>.ConfigureCell {
        return { [unowned self] _, tv, ip, i in
                var cell = tv.dequeueResuableCell(type: HomeViewCell.self, forIndexPath: ip)
                cell.bind(to: self.viewModel.createHomeViewCellModel(for: i))
                return cell
            }
    }
}
