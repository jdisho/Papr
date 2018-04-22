//
//  AddToCollectionViewModel.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol AddToCollectionViewModelInput {
    /// Call when cancel button is pressed
    var cancelAction: CocoaAction { get }
}

protocol AddToCollectionViewModelOutput {
    /// Emites the child viewModels
    var collectionCellModelTypes: Observable<[PhotoCollectionCellModelType]>! { get }
}

protocol AddToCollectionViewModelType {
    var inputs: AddToCollectionViewModelInput { get }
    var outputs: AddToCollectionViewModelOutput { get }
}

class AddToCollectionViewModel: AddToCollectionViewModelInput,
                                AddToCollectionViewModelOutput,
                                AddToCollectionViewModelType  {

    // MARK: Inputs & Outputs
    var inputs: AddToCollectionViewModelInput { return self }
    var outputs: AddToCollectionViewModelOutput { return self }

    // MARK: Inputs
    lazy var cancelAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            self.sceneCoordinator.pop(animated: true)
        }
    }()

    // MARK: Outputs
    var collectionCellModelTypes: Observable<[PhotoCollectionCellModelType]>!

    // MARK: Private
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType

    init(service: CollectionServiceType = CollectionService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
    }

}
