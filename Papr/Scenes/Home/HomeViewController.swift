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
    private let pinterestLayout = PinterestLayout()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    private var navBarButton: UIButton!
    private var rightBarButtonItem: UIBarButtonItem!
    private var collectionViewDataSource: CollectionViewSectionedDataSource<HomeSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(withCellType: HomeViewCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)

            cellModel.outputs.photoSize
                .map { (size) -> CGSize in
                    let (width, height) = size
                    let screenWidth = Double(UIScreen.main.bounds.width)
                    let newHeight = (height * screenWidth / width).rounded()
                    // FIX 😳: 115 is the size of top + bottom bar
                    return CGSize(width: screenWidth, height: newHeight + 115.0)
                }
                .debug()
                .bind(to: self.pinterestLayout.rx.updateSize(indexPath))
                .disposed(by: self.disposeBag)

            return cell
        }
    }

    // MARK: Override
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

        outputs.curated.subscribe { [unowned self] curated in
            guard let curated = curated.element else { return }
            self.navBarButton.rx.action = curated ? inputs.showLatestPhotosAction : inputs.showCuratedPhotosAction
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

        outputs.isRefreshing
            .negate()
            .bind(to: rightBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)

        outputs.navBarButtonName
            .map { $0.string }
            .bind(to: navBarButton.rx.title())
            .disposed(by: disposeBag)
        
        outputs.homeViewCellModelTypes
            .map { [HomeSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.reachedBottom()
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
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
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
