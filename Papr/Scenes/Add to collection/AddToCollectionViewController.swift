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

class AddToCollectionViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: AddToCollectionViewModel!

    // MARK: IBOutlets
    @IBOutlet var addToCollectionButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var transparentViewContainer: UIView!

    // MARK: Private
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        showOverlayView()
        configureCollectionView()
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

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

    private func configureCollectionView() {
        collectionView.registerCell(type: PhotoCollectionViewCell.self)
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
