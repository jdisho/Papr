//
//  SearchService.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct SearchService: SearchServiceType {
    private var unsplash: MoyaProvider<Unsplash>

    init(unsplash: MoyaProvider<Unsplash> = MoyaProvider<Unsplash>()) {
        self.unsplash = unsplash
    }

    func searchPhotos(with query: String, pageNumber: Int) -> Observable<PhotosResult> {
        return unsplash.rx.request(.searchPhotos(
                query: query,
                page: pageNumber,
                perPage: Constants.photosPerPage,
                collections: nil,
                orientation: nil)
            )
            .map(PhotosResult.self)
            .asObservable()
    }

    func searchCollections(with query: String, pageNumber: Int) -> Observable<PhotoCollectionsResult> {
        return unsplash.rx.request(.searchCollections(
                query: query,
                page: pageNumber,
                perPage: 10)
            )
            .map(PhotoCollectionsResult.self)
            .asObservable()
    }

    func searchUsers(with query: String, pageNumber: Int) -> Observable<UsersResult> {
        return unsplash.rx.request(.searchUsers(
                query: query,
                page: pageNumber,
                perPage: 10)
            )
            .map(UsersResult.self)
            .asObservable()
    }

}
