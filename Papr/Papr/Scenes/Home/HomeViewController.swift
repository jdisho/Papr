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

class HomeViewController: UIViewController, BindableType {
    
    // MARK: ViewModel

    var viewModel: HomeViewModel!

    // MARK: IBOutlets

    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Private

    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, Photo>>!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationController()
        configureCollectionView()
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

    // MARK: BindableType

    func bindViewModel() {
        guard let input = viewModel.input else { return }
        let output = viewModel.transform(input: input)

        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Photo>>(
            configureCell: { [unowned self] (dataSource, collectionView, indexPath, item) in 
            var cell = collectionView.dequeueReusableCell(type: HomeViewCell.self, forIndexPath: indexPath)
            cell.bind(to: self.viewModel.createHomeViewCellModel(for: item))
            return cell
        })
        

        output.asyncPhotos
            .map { [SectionModel(model: "", items: Array($0))] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        self.collectionView.rx
            .contentOffset
            .flatMap { [unowned self] _ in 
                Observable
                    .just(self.collectionView.isNearTheBottomEdge())
            }
            .distinctUntilChanged()
            .bind(to: input.loadMore)
            .disposed(by: rx.disposeBag)
    }
}

extension UIScrollView {

    func isNearTheBottomEdge(offset: CGFloat = 100) -> Bool {
        return self.contentOffset.y + self.frame.size.height + offset >= self.contentSize.height
    }

}
