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
    var navigateToCreateCollectionAction: CocoaAction { get }
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

    lazy var navigateToCreateCollectionAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            let viewModel = CreateCollectionViewModel()
            return self.sceneCoordinator.transition(to: .createCollection(viewModel), type: .modal)
        }
    }()

    // MARK: Outputs
    let photoStream: Observable<Photo>
    lazy var  collectionCellModelTypes: Observable<[PhotoCollectionCellModelType]> = {
        Observable.combineLatest(photoStream, myCollectionsStream)
            .map { photo, collections in
                collections.map { PhotoCollectionCellModel(photo: photo, photoCollection: $0) }
            }
    }()

    // MARK: Private
    private var loggedInUser: User!
    private var photo: Photo!
    private var service: CollectionServiceType!
    private var sceneCoordinator: SceneCoordinatorType!
    private var myCollectionsStream: Observable<[PhotoCollection]>!

    lazy var alertAction: Action<String, Void> = {
        Action<String, Void> { [unowned self] message in
            let alertViewModel = AlertViewModel(
                title: "Upsss...",
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(
                to: .alert(alertViewModel),
                type: .alert)
        }
    }()

    init(loggedInUser: User,
         photo: Photo,
         service: CollectionServiceType = CollectionService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.loggedInUser = loggedInUser
        self.photo = photo
        self.service = service
        self.sceneCoordinator = sceneCoordinator

        photoStream = Observable.just(photo)

        var myCollections = [PhotoCollection]()

        myCollectionsStream = service.collections(withUsername: loggedInUser.username ?? "")
            .map { collections -> [PhotoCollection] in
                collections.forEach { collection in
                    myCollections.append(collection)
                }
                return myCollections
            }
            .catchError({ [unowned self] error in
                self.alertAction.execute(error.localizedDescription)
                return Observable.just(myCollections)
            })

    }

}
