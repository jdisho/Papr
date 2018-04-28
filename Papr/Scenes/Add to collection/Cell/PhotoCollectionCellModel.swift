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

protocol PhotoCollectionCellModelInput {
    var addAction: CocoaAction { get }
    var removeAction: CocoaAction { get }
}

protocol PhotoCollectionCellModelOutput {
    var coverPhotoURL: Observable<String> { get }
    var collectionName: Observable<String> { get }
    var isCollectionPrivate: Observable<Bool> { get }
    var isPhotoInCollection: Observable<Bool> { get }
}


protocol PhotoCollectionCellModelType {
    var inputs: PhotoCollectionCellModelInput { get }
    var outputs: PhotoCollectionCellModelOutput { get }
}

class PhotoCollectionCellModel: PhotoCollectionCellModelInput,
                                PhotoCollectionCellModelOutput,
                                PhotoCollectionCellModelType {


    // MARK: Inputs & Outputs
    var inputs: PhotoCollectionCellModelInput { return self }
    var outputs: PhotoCollectionCellModelOutput { return self }

    // MARK: Inputs
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

    // MARK: Outputs
    let coverPhotoURL: Observable<String>
    let collectionName: Observable<String>
    let isCollectionPrivate: Observable<Bool>
    let isPhotoInCollection: Observable<Bool>

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
            return self.sceneCoordinator.transition(
                to: .alert(alertViewModel),
                type: .alert)
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

        let photoCollectionStream = Observable.merge(
            Observable.just(photoCollection),
            service.collection(withID: photoCollection.id ?? 0))
            .catchErrorJustReturn(photoCollection)

        coverPhotoURL = Observable.merge(
            photoCollectionStream.map { $0.coverPhoto?.urls?.thumb }.unwrap(),
            photoProperty.map { $0?.urls?.thumb }.unwrap())

        collectionName = photoCollectionStream
            .map { $0.title ?? "" }

        isCollectionPrivate = photoCollectionStream
            .map { $0.isPrivate ?? false }

        isPhotoInCollection = Observable.combineLatest(Observable.just(photo), photoProperty)
            .map { currentPhoto, updatedPhoto  -> Photo in
                guard let photo = updatedPhoto else { return currentPhoto }
                return photo
            }
            .flatMap { photo in
                service.photos(fromCollectionId: photoCollection.id ?? 0)
                    .map { $0.contains(photo) }
            }
            .catchErrorJustReturn(false)

    }

}
