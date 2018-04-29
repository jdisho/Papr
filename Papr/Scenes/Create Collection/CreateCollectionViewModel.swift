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

class CreateCollectionViewModel: CreateCollectionViewModelInput,
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
                .flatMap { name, description, isPrivate -> Observable<Photo> in
                    return self.service.createCollection(with: name, description: description, isPrivate: isPrivate)
                        .flatMap { result -> Observable<Photo> in
                            switch result {
                            case let .success(collection):
                                return self.addPhotoToCollection(id: collection.id ?? 0, photoId: self.photo.id ?? "")
                            case let .error(error):
                                return .empty()
                            }
                        }
                }
            return result.ignoreAll()
        }
    }()

    private func addPhotoToCollection(id: Int, photoId: String) -> Observable<Photo> {
        return self.service.addPhotoToCollection(withId: id, photoId: photoId)
            .flatMap { result -> Observable<Photo> in
                switch result {
                case let .success(photo):
                    print("success")
                    return .just(photo)
                case let .error(error):
                    print(error)
                    return .empty()
                }
        }
    }

    // MARK: Outputs
    let saveButtonEnabled: Observable<Bool>


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

        saveButtonEnabled = collectionName.map { $0 != "" }
    }
}
