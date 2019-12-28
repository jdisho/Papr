//
//  CreateCollectionViewModel.swift
//  Papr
//
//  Created by Joan Disho on 29.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol CreateCollectionViewModelInput {
    var cancelAction: CocoaAction { get }
    var saveAction: CocoaAction { get }
    var collectionName: BehaviorSubject<String> { get }
    var collectionDescription: BehaviorSubject<String> { get }
    var isPrivate: BehaviorSubject<Bool> { get }
}

protocol CreateCollectionViewModelOutput {
    var saveButtonEnabled: Observable<Bool> { get }
}

protocol CreateCollectionViewModelType {
    var inputs: CreateCollectionViewModelInput { get }
    var outputs: CreateCollectionViewModelOutput {  get}
}

final class CreateCollectionViewModel: CreateCollectionViewModelInput,
                                CreateCollectionViewModelOutput,
                                CreateCollectionViewModelType  {

    // MARK: Inputs & Outputs
    var inputs: CreateCollectionViewModelInput { return self }
    var outputs: CreateCollectionViewModelOutput { return self }

    // MARK: Inputs
    let collectionName = BehaviorSubject<String>(value: "")
    let collectionDescription = BehaviorSubject<String>(value: "")
    let isPrivate = BehaviorSubject<Bool>(value: false)

    lazy var cancelAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            self.sceneCoordinator.pop(animated: true)
        }
    }()

    lazy var saveAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            let result = Observable.combineLatest(self.collectionName, self.collectionDescription, self.isPrivate)
                .take(1)
                .flatMap { name, description, isPrivate -> Observable<Photo> in
                    self.createCollection(with: name, description: description, isPrivate: isPrivate)
                        .flatMap { collection -> Observable<Photo> in
                            self.addPhotoToCollection(collection)
                        }
                }
            return result.ignoreAll()
        }
    }()

    // MARK: Outputs
    let saveButtonEnabled: Observable<Bool>


    // MARK: Private
    private let photo: Photo
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType

    private lazy var alertAction: Action<Papr.Error, Void> = {
        Action<Papr.Error, Void> { [unowned self] error in
            let alertViewModel = AlertViewModel(
                title: "Upsss...",
                message: error.errorDescription,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()

    init(photo: Photo,
         service: CollectionServiceType = CollectionService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.photo = photo
        self.service = service
        self.sceneCoordinator = sceneCoordinator

        saveButtonEnabled = collectionName.map { $0 != "" }
    }

    // MARK: Helpers

    private func addPhotoToCollection(_ collection: PhotoCollection) -> Observable<Photo> {
        guard let collectionId = collection.id,
            let photoId = photo.id else { return Observable.empty() }
        return service.addPhotoToCollection(withId: collectionId, photoId: photoId)
            .flatMap { result -> Observable<Photo> in
                switch result {
                case let .success(photo):
                    self.sceneCoordinator.pop(animated: true)
                    return .just(photo)
                case let .failure(error):
                    self.alertAction.execute(error)
                    return .empty()
                }
            }
    }

    private func createCollection(with name: String, description: String, isPrivate: Bool) -> Observable<PhotoCollection> {
        return service.createCollection(with: name, description: description, isPrivate: isPrivate)
            .flatMap { result -> Observable<PhotoCollection> in
                switch result {
                case let .success(collection):
                    return .just(collection)
                case let .failure(error):
                    self.alertAction.execute(error)
                    return .empty()
                }
        }
    }
}
