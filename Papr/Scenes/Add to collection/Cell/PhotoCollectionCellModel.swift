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
    var addAction: Action<(photo: Photo, collection: PhotoCollection), Void> { get }
}

protocol PhotoCollectionCellModelOutput {
    var coverPhotoURL: Observable<String> { get }
    var collectionName: Observable<String> { get }
    var isCollectionPrivate: Observable<Bool> { get }
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
    lazy var addAction: Action<(photo: Photo, collection: PhotoCollection), Void> = {
        return Action<(photo: Photo, collection: PhotoCollection), Void> { (photo, collection) in
            return .empty()
        }
    }()

    // MARK: Outputs
    let coverPhotoURL: Observable<String>
    let collectionName: Observable<String>
    let isCollectionPrivate: Observable<Bool>

    // MARK: Private
    private let photoCollection: PhotoCollection

    init(photoCollection: PhotoCollection) {
        self.photoCollection = photoCollection

        let photoCollectionStream = Observable.just(photoCollection)

        coverPhotoURL = photoCollectionStream
            .map { $0.coverPhoto?.urls?.thumb ?? "" }

        collectionName = photoCollectionStream
            .map { $0.title ?? "" }

        isCollectionPrivate = photoCollectionStream
            .map { $0.isPrivate ?? false }


    }

}
