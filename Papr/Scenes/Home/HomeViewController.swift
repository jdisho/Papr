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
import VanillaConstraints

class HomeViewController: UIViewController, BindableType {

    typealias HomeSectionModel = SectionModel<String, HomeViewCellModelType>
    
    // MARK: ViewModel
    var viewModel: HomeViewModelType!

    // MARK: Private
    private let disposeBag = DisposeBag()
    private let collectionViewLayout: UICollectionViewLayout!
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    private var rightBarButtonItem: UIBarButtonItem!
    private var collectionViewDataSource: CollectionViewSectionedDataSource<HomeSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(withCellType: HomeViewCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)

            if let pinterestLayout = collectionView.collectionViewLayout as? PinterestLayout {
                cellModel.outputs.photoSize
                    .map { CGSize(width: $0, height: $1) }
                    .bind(to: pinterestLayout.rx.updateSize(indexPath))
                    .disposed(by: self.disposeBag)
            }
            return cell
        }
    }

    // MARK: Override
    init(collectionViewLayout: UICollectionViewLayout) {
        self.collectionViewLayout = collectionViewLayout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationController()
        configureCollectionView()
        configureRefreshControl()
    }

    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let rightBarButtonItemTap = rightBarButtonItem.rx.tap.share()
        
        rightBarButtonItemTap
            .scan(into: OrderBy.latest) { result, _ in
                result = (result == .latest) ? .popular : .latest
            }
            .bind(to: inputs.orderByProperty)
            .disposed(by: disposeBag)

        rightBarButtonItemTap
            .merge(with: refreshControl.rx.controlEvent(.valueChanged).asObservable())
            .map(to: true)
            .bind(to: inputs.refreshProperty)
            .disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom()
            .bind(to: inputs.loadMoreProperty)
            .disposed(by: disposeBag)
        
        outputs.isOrderBy
            .map { $0 == .popular ? Papr.Appearance.Icon.flame : Papr.Appearance.Icon.arrowUpRight }
            .bind(to: rightBarButtonItem.rx.image)
            .disposed(by: disposeBag)
        
        outputs.isFirstPageRequested
            .negate()
            .bind(to: inputs.refreshProperty)
            .disposed(by: disposeBag)

        outputs.isRefreshing
            .merge(with: outputs.isLoadingMore)
            .negate()
            .bind(to: rightBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
        outputs.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing(in: collectionView))
            .disposed(by: disposeBag)
        
        outputs.homeViewCellModelTypes
            .map { [HomeSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureNavigationController() {
        rightBarButtonItem = UIBarButtonItem()
        navigationItem.title = "Home"
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.add(to: view).pinToEdges()
        collectionView.register(cellType: HomeViewCell.self)
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: collectionViewDataSource
        )
    }

    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        collectionView.addSubview(refreshControl)
    }
}
