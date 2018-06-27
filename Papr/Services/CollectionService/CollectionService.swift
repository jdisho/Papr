//
//  CollectionService.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct CollectionService: CollectionServiceType {

    private var unsplash: MoyaProvider<MultiTarget>

    init(unsplash: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.unsplash = unsplash
    }

    func collection(withID id: Int) -> Observable<PhotoCollection> {
        return unsplash.rx.request(MultiTarget(Unsplash.collection(id: id)))
            .map(PhotoCollection.self)
            .asObservable()
    }

    func collections(withUsername username: String) -> Observable<[PhotoCollection]> {
            return self.unsplash.rx
                .request(MultiTarget(Unsplash.userCollections(username: username, page: 1, perPage: 20)))
                .map([PhotoCollection].self)
                .asObservable()
        }

    func photos(fromCollectionId id: Int) -> Observable<[Photo]> {
        return unsplash.rx.request(MultiTarget(Unsplash.collectionPhotos(id: id, page: 1, perPage: 10)))
            .map([Photo].self)
            .asObservable()
    }

    func addPhotoToCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, String>> {
        return unsplash.rx.request(MultiTarget(Unsplash.addPhotoToCollection(collectionID: id, photoID: photoId)))
            .map(CollectionResponse.self)
            .map { $0.photo }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { _ in .just(.error("Failed to add photo to the collection")) }
    }

    func removePhotoFromCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, String>> {
        return unsplash.rx.request(MultiTarget(Unsplash.removePhotoFromCollection(collectionID: id, photoID: photoId)))
            .map(CollectionResponse.self)
            .map { $0.photo }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { _ in .just(.error("Failed to remove photo from the collection")) }
    }

    func createCollection(
        with title: String,
        description: String,
        isPrivate: Bool
        ) -> Observable<Result<PhotoCollection, String>> {

        return unsplash.rx.request(MultiTarget(Unsplash.createCollection(
            title: title,
            description: description,
            isPrivate: isPrivate)))
            .map(PhotoCollection.self)
            .asObservable()
            .map (Result.success)
            .catchError { _ in .just(.error("Failed to create the collection")) }
    }

    
}

