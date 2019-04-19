//
//  CollectionService.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct CollectionService: CollectionServiceType {

    private let unsplash: TinyNetworking<Unsplash>
    private let cache: Cache

    init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>(), cache: Cache = .shared) {
        self.unsplash = unsplash
        self.cache = cache
    }

    func collection(withID id: Int) -> Observable<PhotoCollection> {
        return unsplash.rx.request(resource: .collection(id: id))
            .map(to: PhotoCollection.self)
            .asObservable()
    }

    func collections(withUsername username: String) -> Observable<[PhotoCollection]> {
            return self.unsplash.rx
                .request(resource: .userCollections(username: username, page: 1, perPage: 20))
                .map(to: [PhotoCollection].self)
                .asObservable()
    }

    func collections(byPageNumber page: Int, curated: Bool) -> Observable<Result<[PhotoCollection], String>> {
        let collections: Unsplash = curated ?
            .curatedCollections(page: page, perPage: 20) :
            .featuredCollections(page: page, perPage: 20)

        return unsplash.rx.request(resource: collections)
            .map(to: [PhotoCollection].self)
            .asObservable()
            .map(Result.success)
            .catchError { .just(.error($0.localizedDescription)) }
    }

    func photos(fromCollectionId id: Int, pageNumber: Int) -> Observable<[Photo]> {
        return unsplash.rx.request(resource: .collectionPhotos(id: id, page: pageNumber, perPage: 10))
            .map(to: [Photo].self)
            .asObservable()
            .execute { self.cache.set(values: $0) }  // 👨‍👩‍👧‍👧 Populate the cache.
    }

    func addPhotoToCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, String>> {
        return unsplash.rx.request(resource: .addPhotoToCollection(collectionID: id, photoID: photoId))
            .map(to: CollectionResponse.self)
            .map { $0.photo }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { _ in .just(.error("Failed to add photo to the collection")) }
    }

    func removePhotoFromCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, String>> {
        return unsplash.rx.request(resource: .removePhotoFromCollection(collectionID: id, photoID: photoId))
            .map(to: CollectionResponse.self)
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

        return unsplash.rx.request(resource: .createCollection(
            title: title,
            description: description,
            isPrivate: isPrivate))
            .map(to: PhotoCollection.self)
            .asObservable()
            .map (Result.success)
            .catchError { _ in .just(.error("Failed to create the collection")) }
    }

    
}

