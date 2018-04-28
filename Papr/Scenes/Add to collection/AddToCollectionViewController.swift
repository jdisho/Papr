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
import Nuke

class AddToCollectionViewController: UIViewController, BindableType {

    typealias AddToCollectionSectionModel = SectionModel<String, PhotoCollectionCellModelType>

    // MARK: ViewModel
    var viewModel: AddToCollectionViewModel!

    // MARK: IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoActivityIndicator: UIActivityIndicatorView!

    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<AddToCollectionSectionModel>!
    private let disposeBag = DisposeBag()
    private static let nukeManager = Nuke.Manager.shared
    private var cancelBarButton: UIBarButtonItem!
    private var addToCollectionBarButton: UIBarButtonItem!
    private var collectionViewActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureCollectionViewActivityIndicator()
        configureCollectionView()
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = AddToCollectionViewController.self

        outputs.photoStream
            .map { $0.urls?.full }
            .unwrap()
            .flatMap { this.nukeManager.loadImage(with: $0).orEmpty }
            .flatMapIgnore { [unowned self] _ in
                Observable.just(self.photoActivityIndicator.stopAnimating())
            }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.collectionCellModelTypes
            .map { [AddToCollectionSectionModel(model: "", items: $0)] }
            .flatMapIgnore { [unowned self] _ in
                Observable.just(self.collectionViewActivityIndicator.stopAnimating())
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        cancelBarButton.rx.action = inputs.cancelAction

    }

    // MARK: UI
    private func configureNavigationBar() {
        title = "Add to collection"
        cancelBarButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: nil
        )
        addToCollectionBarButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "add-black"),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = addToCollectionBarButton
        navigationController?.navigationBar.tintColor = .black
    }

    private func configureCollectionViewActivityIndicator() {
        collectionViewActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        collectionView.addSubview(collectionViewActivityIndicator)
        collectionViewActivityIndicator.center = CGPoint(x: collectionView.frame.width/2, y: collectionView.frame.height/2)
        collectionViewActivityIndicator.startAnimating()
        collectionViewActivityIndicator.hidesWhenStopped = true
    }

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
}
