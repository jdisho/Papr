//
//  SearchPhotosViewController.swift
//  Papr
//
//  Created by Joan Disho on 26.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchPhotosViewController: UIViewController, BindableType {

    typealias SearchPhotosSectionModel = SectionModel<String, SearchPhotosCellModelType>

    // MARK: ViewModel
    var viewModel: SearchPhotosViewModelType!

    // MARK: Privates
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewLayout!
    private var loadingView: LoadingView!
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SearchPhotosSectionModel>!
    private var collectionViewDataSource: CollectionViewSectionedDataSource<SearchPhotosSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(withCellType: SearchPhotosCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)

            if let pinterestLayout = collectionView.collectionViewLayout as? PinterestLayout {
                cellModel.outputs.photoSize
                    .map { CGSize(width: $0.0, height: $0.1) }
                    .bind(to: pinterestLayout.rx.updateSize(indexPath))
                    .disposed(by: self.disposeBag)
            }

            return cell
        }
    }

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

        configureCollectionView()
        configureLoadingView()
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        outputs.navTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)

        outputs.searchPhotosCellModelType
            .map { [SearchPhotosSectionModel(model: "", items: $0)] }
            .execute { [unowned self] _ in
                self.loadingView.stopAnimating()
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.reachedBottom()
            .bind(to: inputs.loadMore)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<SearchPhotosCell> in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? SearchPhotosCell
                    else { return .empty() }
                return .just(cell)
            }
            .flatMap { $0.viewModel.outputs.photoStream }
            .bind(to: inputs.photoDetailsAction.inputs)
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureLoadingView() {
        loadingView = LoadingView(frame: collectionView.frame)
        loadingView.add(to: view).pinToEdges()
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.add(to: view).pinToEdges()
        collectionView.register(cellType: SearchPhotosCell.self)
        dataSource = RxCollectionViewSectionedReloadDataSource<SearchPhotosSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }
}


