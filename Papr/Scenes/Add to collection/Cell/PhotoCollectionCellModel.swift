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
            .empty()
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

    init(photo: Photo,
         photoCollection: PhotoCollection,
         service: CollectionServiceType = CollectionService()) {

        self.photo = photo
        self.photoCollection = photoCollection
        self.service = service

        let photoCollectionStream = Observable.just(photoCollection)

        coverPhotoURL = photoCollectionStream
            .map { $0.coverPhoto?.urls?.thumb ?? "" }

        collectionName = photoCollectionStream
            .map { $0.title ?? "" }

        isCollectionPrivate = photoCollectionStream
            .map { $0.isPrivate ?? false }

        isPhotoInCollection = Observable.combineLatest(
            Observable.just(photo),
            service.photos(fromCollectionId: photoCollection.id ?? 0)
            )
            .map { newPhoto, photos -> Bool in
                photos.contains(newPhoto)
            }

    }

}
