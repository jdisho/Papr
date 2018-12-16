//
//  PhotoCollectionCellModel.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

class PhotoCollectionCellModel: AutoModel {

    // MARK: Inputs
    /// sourcery:begin: input
    lazy var addAction: CocoaAction = {
        return CocoaAction {
            guard let collectionID = self.photoCollection.id,
                let photoID = self.photo.id else { return Observable.empty() }
            return self.service
                .addPhotoToCollection(withId: collectionID, photoId: photoID)
                .flatMap { result -> Observable<Void> in
                    switch result {
                    case let .success(photo):
                        self.photoProperty.onNext(photo)
                    case let .error(error):
                        self.alertAction.execute(error)
                    }
                    return .empty()
                }
        }
    }()

    lazy var removeAction: CocoaAction = {
        return CocoaAction {
            guard let collectionID = self.photoCollection.id,
                let photoID = self.photo.id else { return Observable.empty() }
            return self.service
                .removePhotoFromCollection(withId: collectionID, photoId: photoID)
                .flatMap { result -> Observable<Void> in
                    switch result {
                    case let .success(photo):
                        self.photoProperty.onNext(photo)
                    case let .error(error):
                        self.alertAction.execute(error)
                    }
                    return .empty()
            }
        }
    }()
    /// sourcery:end

    // MARK: Outputs
    /// sourcery:begin: output
    let coverPhotoURL: Observable<String>
    let collectionName: Observable<String>
    let isCollectionPrivate: Observable<Bool>
    let isPhotoInCollection: Observable<Bool>
    /// sourcery:end

    // MARK: Private
    private let photo: Photo
    private let photoCollection: PhotoCollection
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let photoProperty = BehaviorSubject<Photo?>(value: nil)

    private lazy var alertAction: Action<String, Void> = {
        Action<String, Void> { [unowned self] message in
            let alertViewModel = AlertViewModel(
                title: "Upsss...",
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()

    init(photo: Photo,
         photoCollection: PhotoCollection,
         service: CollectionServiceType = CollectionService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.photo = photo
        self.photoCollection = photoCollection
        self.service = service
        self.sceneCoordinator = sceneCoordinator

        let photoCollectionStream = Observable.just(photoCollection)
            .merge(with: service.collection(withID: photoCollection.id ?? 0))
            .catchErrorJustReturn(photoCollection)

        coverPhotoURL = photoCollectionStream
            .map { $0.coverPhoto?.urls?.thumb }
            .unwrap()

        collectionName = photoCollectionStream
            .map { $0.title }
            .unwrap()

        isCollectionPrivate = photoCollectionStream
            .map { $0.isPrivate }
            .unwrap()

        isPhotoInCollection = Observable.combineLatest(Observable.just(photo), photoProperty)
            .map { currentPhoto, updatedPhoto  -> Photo in
                guard let photo = updatedPhoto else { return currentPhoto }
                return photo
            }
            .flatMap { photo in
                service.photos(fromCollectionId: photoCollection.id ?? 0, pageNumber: 1)
                    .map { $0.contains(photo) }
            }
            .catchErrorJustReturn(false)
    }

}
