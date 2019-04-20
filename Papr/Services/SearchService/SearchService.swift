//
//  SearchService.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct SearchService: SearchServiceType {
    private let unsplash: TinyNetworking<Unsplash>
    private let cache: Cache

    init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>(), cache: Cache = .shared) {
        self.unsplash = unsplash
        self.cache = cache
    }

    func searchPhotos(with query: String, pageNumber: Int) -> Observable<PhotosResult> {
        return unsplash.rx.request(resource: .searchPhotos(
                query: query,
                page: pageNumber,
                perPage: 10,
                collections: nil,
                orientation: nil)
            )
            .map(to: PhotosResult.self)
            .asObservable()
            .execute { self.cache.set(values: $0.results ?? []) }
    }

    func searchCollections(with query: String, pageNumber: Int) -> Observable<PhotoCollectionsResult> {
        return unsplash.rx.request(resource: .searchCollections(
                query: query,
                page: pageNumber,
                perPage: 10)
            )
            .map(to: PhotoCollectionsResult.self)
            .asObservable()
    }

    func searchUsers(with query: String, pageNumber: Int) -> Observable<UsersResult> {
        return unsplash.rx.request(resource: .searchUsers(
                query: query,
                page: pageNumber,
                perPage: 10)
            )
            .map(to: UsersResult.self)
            .asObservable()
    }

}
