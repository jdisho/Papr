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

    private var unsplash: MoyaProvider<Unsplash>

    init(unsplash: MoyaProvider<Unsplash> = MoyaProvider<Unsplash>()) {
        self.unsplash = unsplash
    }

    func collection(withID id: Int) -> Observable<PhotoCollection> {
        return unsplash.rx.request(.collection(id: id))
            .map(PhotoCollection.self)
            .asObservable()
    }

    func collections(withUsername username: String) -> Observable<[PhotoCollection]> {
            return self.unsplash.rx
                .request(.userCollections(username: username, page: 1, perPage: 20))
                .map([PhotoCollection].self)
                .asObservable()
    }

    func collections(byPageNumber page: Int, curated: Bool) -> Observable<Result<[PhotoCollection], String>> {
        
        let collections: Unsplash = curated ?
            .curatedCollections(page: page, perPage: 20) :
            .featuredCollections(page: page, perPage: 20)

        return unsplash.rx.request(collections)
            .map([PhotoCollection].self)
            .asObservable()
            .map(Result.success)
            .catchError { error in
                return .just(.error(error.localizedDescription))
            }
    }

    func photos(fromCollectionId id: Int) -> Observable<[Photo]> {
        return unsplash.rx.request(.collectionPhotos(id: id, page: 1, perPage: 10))
            .map([Photo].self)
            .asObservable()
    }

    func addPhotoToCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, String>> {
        return unsplash.rx.request(.addPhotoToCollection(collectionID: id, photoID: photoId))
            .map(CollectionResponse.self)
            .map { $0.photo }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { _ in .just(.error("Failed to add photo to the collection")) }
    }

    func removePhotoFromCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, String>> {
        return unsplash.rx.request(.removePhotoFromCollection(collectionID: id, photoID: photoId))
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

        return unsplash.rx.request(.createCollection(
            title: title,
            description: description,
            isPrivate: isPrivate))
            .map(PhotoCollection.self)
            .asObservable()
            .map (Result.success)
            .catchError { _ in .just(.error("Failed to create the collection")) }
    }

    
}

