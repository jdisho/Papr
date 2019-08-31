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
    private var collectionView: UICollectionView!
    private var dataSource: RxCollectionViewSectionedReloadDataSource<CollectionsSectionModel>!
    private var refreshControl: UIRefreshControl!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Explore 🌄"

        configureCollectionView()
        configureRefreshControl()
    }

    func bindViewModel() {
        let input = viewModel.input
        let output = viewModel.output

        output.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        output.collectionCellsModelType
            .map { [CollectionsSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.reachedBottom()
            .bind(to: input.loadMore)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<CollectionCell> in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? CollectionCell
                    else { return .empty() }
                return .just(cell)
            }
            .map { $0.viewModel }
            .flatMap { $0.output.photoCollection }
            .bind(to: input.collectionDetailsAction.inputs)
            .disposed(by: disposeBag)
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.add(to: view).pinToEdges()

        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let spacing = (1 / UIScreen.main.scale) + 16
        let cellWidth = (UIScreen.main.bounds.width / 2) - spacing

        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: 16.0, left: 8.0, bottom: 0, right: 8.0)
        flowLayout.minimumLineSpacing = spacing

        collectionView.register(cellType: CollectionCell.self)
        dataSource = RxCollectionViewSectionedReloadDataSource<CollectionsSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }

    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    @objc private func refresh() {
        viewModel.input.refresh()
    }

    private var collectionViewDataSource: CollectionViewSectionedDataSource<CollectionsSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell: CollectionCell = self.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.bind(to: cellModel)
            return cell
        }
    }
}
