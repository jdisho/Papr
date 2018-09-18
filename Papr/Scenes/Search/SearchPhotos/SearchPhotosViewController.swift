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

    // MARK: IBOutlets
    @IBOutlet var collectionView: UICollectionView!

    // MARK: Privates
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SearchPhotosSectionModel>!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }

    func bindViewModel() {
        let outputs = viewModel.outputs

        outputs.searchPhotosCellModelType
            .map { [SearchPhotosSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureCollectionView() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let spacing = 2 / UIScreen.main.scale
        let cellWidth = (UIScreen.main.bounds.width / 3) - spacing

        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing

        collectionView.register(cellType: SearchPhotosCell.self)

        dataSource = RxCollectionViewSectionedReloadDataSource<SearchPhotosSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }

    private var collectionViewDataSource: CollectionViewSectionedDataSource<SearchPhotosSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(withCellType: SearchPhotosCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)
            return cell
        }
    }
}


