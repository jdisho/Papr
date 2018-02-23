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
    private var navBarButton: UIButton!
    private var rightBarButtonItem: UIBarButtonItem!

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
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        dataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell:  tableViewDataSource
        )

        outputs.curated.subscribe { [unowned self] curated in
            guard let curated = curated.element else { return }
            self.resetTableViewPosition()
            if curated {
                 self.navBarButton.rx.action = inputs.showLatestPhotosAction
            } else {
                 self.navBarButton.rx.action = inputs.showCuratedPhotosAction
            }
        }
        .disposed(by: rx.disposeBag)
        
        outputs.orderBy.subscribe { [unowned self] orderBy in
            guard let orderBy = orderBy.element else { return }
            self.resetTableViewPosition()
            switch orderBy {
            case .latest:
                self.rightBarButtonItem.rx.action = inputs.orderByPopularityAction
            case .popular:
                self.rightBarButtonItem.rx.action = inputs.orderByFrequencyAction
            case .oldest: 
                self.rightBarButtonItem.rx.action = nil
            }
        }
        .disposed(by: rx.disposeBag)

        outputs.orderBy
            .map { $0 == .popular ? #imageLiteral(resourceName: "hot") : #imageLiteral(resourceName: "new")}
            .bind(to: rightBarButtonItem.rx.image)
            .disposed(by: rx.disposeBag)

        outputs.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: rx.disposeBag)

        outputs.navBarButtonName
            .map { $0.string }
            .bind(to: navBarButton.rx.title())
            .disposed(by: rx.disposeBag)

        outputs.photos
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        tableView.rx
            .contentOffset
            .flatMap { [unowned self] _ in 
                return Observable.just(self.tableView.isNearTheBottomEdge())
            }
            .distinctUntilChanged()
            .skipUntil(outputs.isRefreshing)
            .bind(to: inputs.loadMore)
            .disposed(by: rx.disposeBag)
    }

    // MARK: UI
    
    private func configureNavigationController() {
        navBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        navBarButton.setTitleColor(.black, for: .normal)
        navBarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        rightBarButtonItem = UIBarButtonItem()
        navigationItem.titleView = navBarButton
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
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
    
    private func resetTableViewPosition() {
        tableView.setContentOffset(CGPoint(x: 0, y: -150), animated: true)
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
