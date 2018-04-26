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
    var cancelAction: CocoaAction { get }
}

protocol AddToCollectionViewModelOutput {
    var collectionCellModelTypes: Observable<[PhotoCollectionCellModelType]> { get }
    var photoStream: Observable<Photo> { get }
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
    let photoStream: Observable<Photo>
    lazy var  collectionCellModelTypes: Observable<[PhotoCollectionCellModelType]> = {
        return Observable.combineLatest(Observable.just(photo), service.myCollections())
            .map { photo, collections in
                collections.map {
                    PhotoCollectionCellModel(photo: photo, photoCollection: $0)
                }
            }
    }()

    // MARK: Private
    private let photo: Photo
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType

    init(photo: Photo,
         service: CollectionServiceType = CollectionService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.photo = photo
        self.service = service
        self.sceneCoordinator = sceneCoordinator

        photoStream = Observable.just(photo)
    }

}
