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

    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Private

    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    private var refreshControl: UIRefreshControl!

    // MARK: Override

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationController()
        configureRefreshControl()
        configureCollectionView()
        refresh()
    }

    // MARK: BindableType
    
    func bindViewModel() {
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell:  collectionViewDataSource()
        )
        
        viewModel.outputs.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        
        viewModel.outputs.photos
            .map { [SectionModel(model: "", items: Array($0))] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        collectionView.rx
            .contentOffset
            .flatMap { [unowned self] _ in 
                Observable.just(self.collectionView.isNearTheBottomEdge())
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
    
    private func configureCollectionView() {
        collectionView.registerCell(type: HomeViewCell.self)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc private func refresh() {
        viewModel.inputs.refresh()
    }
    
    func collectionViewDataSource() -> CollectionViewSectionedDataSource<HomeSectionModel>.ConfigureCell {
        return 
            { [unowned self] _, cv, ip, i in
                var cell = cv.dequeueReusableCell(type: HomeViewCell.self, forIndexPath: ip)
                cell.bind(to: self.viewModel.createHomeViewCellModel(for: i))
                return cell
            }
    }
}
