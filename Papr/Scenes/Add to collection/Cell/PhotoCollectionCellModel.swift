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
    var coverPhotoURL: Observable<URL> { get }
    var collectionName: Observable<String> { get }
    var isCollectionPrivate: Observable<Bool> { get }
    var isPhotoInCollection: Observable<Bool> { get }
}


protocol PhotoCollectionCellModelType {
    var inputs: PhotoCollectionCellModelInput { get }
    var outputs: PhotoCollectionCellModelOutput { get }
}

final class PhotoCollectionCellModel: PhotoCollectionCellModelInput,
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
                    case let .failure(error):
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
                    case let .failure(error):
                        self.alertAction.execute(error)
                    }
                    return .empty()
            }
        }
    }()

    // MARK: Outputs
    let coverPhotoURL: Observable<URL>
    let collectionName: Observable<String>
    let isCollectionPrivate: Observable<Bool>
    let isPhotoInCollection: Observable<Bool>

    // MARK: Private
    private let photo: Photo
    private let photoCollection: PhotoCollection
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let photoProperty = BehaviorSubject<Photo?>(value: nil)

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
            .mapToURL()

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
