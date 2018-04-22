//
//  AddToCollectionViewController.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import Action
import RxDataSources

class AddToCollectionViewController: UIViewController, BindableType {

    typealias AddToCollectionSectionModel = SectionModel<String, PhotoCollectionCellModelType>

    // MARK: ViewModel
    var viewModel: AddToCollectionViewModel!

    // MARK: IBOutlets
    @IBOutlet var addToCollectionButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var transparentViewContainer: UIView!

    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<AddToCollectionSectionModel>!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        showOverlayView()
        configureCollectionView()
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        outputs.collectionCellModelTypes
            .map { [AddToCollectionSectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        cancelButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                UIView.animate(withDuration: 0.2, animations: {
                    self.transparentViewContainer.backgroundColor = .clear
                })

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    inputs.cancelAction.execute(())
                }
            })
            .disposed(by: disposeBag)

    }

    // MARK: UI
    private func configureCollectionView() {
        collectionView.registerCell(type: PhotoCollectionViewCell.self)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.itemSize = CGSize(width: 100, height: 134)

        dataSource = RxCollectionViewSectionedReloadDataSource<AddToCollectionSectionModel>(
            configureCell:  collectionViewDataSource
        )
    }

    private var collectionViewDataSource: CollectionViewSectionedDataSource<AddToCollectionSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, cellModel in
            var cell = collectionView.dequeueReusableCell(
                type: PhotoCollectionViewCell.self,
                forIndexPath: indexPath)
            cell.bind(to: cellModel)

            return cell
        }
    }

    private func showOverlayView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.transparentViewContainer.backgroundColor = .black
                self.transparentViewContainer.alpha = 0.2

            })
        }
    }

}
