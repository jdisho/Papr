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

class HomeViewController: UIViewController, BindableType {

    typealias HomeSectionModel = SectionModel<String, HomeViewCellModelType>
    
    // MARK: ViewModel
    var viewModel: HomeViewModelType!

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
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

        outputs.curated.subscribe { [unowned self] curated in
            guard let curated = curated.element else { return }
            if curated {
                 self.navBarButton.rx.action = inputs.showLatestPhotosAction 
            } else {
                self.navBarButton.rx.action  = inputs.showCuratedPhotosAction
            }
        }
        .disposed(by: disposeBag)
        
        outputs.orderBy.subscribe { [unowned self] orderBy in
            guard let orderBy = orderBy.element else { return }
            switch orderBy {
            case .latest:
                self.rightBarButtonItem.rx.action = inputs.orderByPopularityAction
            case .popular:
                self.rightBarButtonItem.rx.action = inputs.orderByFrequencyAction
            case .oldest: 
                self.rightBarButtonItem.rx.action = nil
            }
        }
        .disposed(by: disposeBag)

        outputs.orderBy
            .map { $0 == .popular ? #imageLiteral(resourceName: "hot") : #imageLiteral(resourceName: "up")}
            .bind(to: rightBarButtonItem.rx.image)
            .disposed(by: disposeBag)

        outputs.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        outputs.navBarButtonName
            .map { $0.string }
            .bind(to: navBarButton.rx.title())
            .disposed(by: disposeBag)
        
        outputs.homeViewCellModelTypes
            .map { [HomeSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .contentOffset
            .flatMap { [unowned self] _ in 
                return Observable.just(self.tableView.isNearTheBottomEdge())
            }
            .distinctUntilChanged()
            .skipUntil(outputs.isRefreshing)
            .bind(to: inputs.loadMore)
            .disposed(by: disposeBag)
    }

    // MARK: UI

    private func configureNavigationController() {
        navBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        navBarButton.setTitleColor(.black, for: .normal)
        navBarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        rightBarButtonItem = UIBarButtonItem()
        navigationItem.titleView = navBarButton
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = .black
    }

    private func configureTableView() {
        tableView.registerCell(type: HomeViewCell.self)
        tableView.estimatedRowHeight = 400

        dataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell:  tableViewDataSource
        )
    }

    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc private func refresh() {
        viewModel.inputs.refresh()
    }

    private var tableViewDataSource: TableViewSectionedDataSource<HomeSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueResuableCell(
                type: HomeViewCell.self,
                forIndexPath: indexPath)
            cell.bind(to: cellModel)

            return cell
        }
    }
}
