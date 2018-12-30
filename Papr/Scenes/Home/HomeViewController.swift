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
    private var segmentedControl: UISegmentedControl!
    private var rightBarButtonItem: UIBarButtonItem!
    private var collectionViewDataSource: CollectionViewSectionedDataSource<HomeSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(withCellType: HomeViewCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)

            if let pinterestLayout = collectionView.collectionViewLayout as? PinterestLayout {
                cellModel.outputs.photoSize
                    .map { (size) -> CGSize in
                        let (width, height) = size
                        let screenWidth = Double(UIScreen.main.bounds.width)
                        let newHeight = (height * screenWidth / width).rounded()
                        // FIX 😳: 115 is the size of top + bottom bar
                        return CGSize(width: screenWidth, height: newHeight + 115.0)
                    }
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
        refresh()
    }

    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        outputs.orderBy
            .bind { [weak self] in
                self?.rightBarButtonItem.rx.bind(to: inputs.orderByAction, input: $0)
            }
            .disposed(by: disposeBag)

        outputs.orderBy
            .map { $0 == .popular ? #imageLiteral(resourceName: "hot") : #imageLiteral(resourceName: "up")}
            .bind(to: rightBarButtonItem.rx.image)
            .disposed(by: disposeBag)

        outputs.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        outputs.isRefreshing
            .negate()
            .bind(to: rightBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)

        outputs.homeViewCellModelTypes
            .map { [HomeSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.reachedBottom()
            .skipUntil(outputs.isRefreshing)
            .bind(to: inputs.loadMore)
            .disposed(by: disposeBag)

        segmentedControl.rx.value
            .map { $0 == 0 ? .newest : .curated }
            .bind(to: inputs.showPhotosAction.inputs)
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureNavigationController() {
        segmentedControl = UISegmentedControl(items: PhotosType.allCases.map { $0.rawValue })
        segmentedControl.selectedSegmentIndex = 0
        rightBarButtonItem = UIBarButtonItem()
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.add(to: view).pinToEdges()
        collectionView.register(cellType: HomeViewCell.self)
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }

    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    @objc private func refresh() {
        viewModel.inputs.refresh()
    }
}
