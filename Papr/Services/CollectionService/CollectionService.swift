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

    func collections(
        withUsername username: String,
        byPageNumber pageNumber: Int
        ) -> Observable<[PhotoCollection]> {
            return self.unsplash.rx
                .request(.userCollections(username: username, page: pageNumber, perPage: Constants.photosPerPage))
                .map([PhotoCollection].self)
                .asObservable()
        }

    func photos(fromCollectionId id: Int) -> Observable<[Photo]> {
        return unsplash.rx.request(.collectionPhotos(id: id, page: 1, perPage: 10))
            .map([Photo].self)
            .asObservable()
    }

    func addPhotoToCollection(withCollectionId id: Int, photoId: String) -> Observable<Result<PhotoCollection, String>> {
        return unsplash.rx.request(.addPhotoToCollection(collectionID: id, photoID: photoId))
            .map(AddToCollectionResponse.self)
            .map { $0.collection }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { _ in .just(.error("Failed to add photo to the collection")) }

    }

    
}

