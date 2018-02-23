//
//  PhotoService.swift
//  Papr
//
//  Created by Joan Disho on 08.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct PhotoService: PhotoServiceType {

    private var provider: MoyaProvider<UnsplashAPI>
    
    init(provider: MoyaProvider<UnsplashAPI> = MoyaProvider<UnsplashAPI>()) {
        self.provider = provider
    }

    func like(photoWithId id: String) -> Observable<Photo?> {
        return provider.rx
            .request(.likePhoto(id: id))
            .asObservable()
            .mapOptional(LikeUnlike.self)
            .map { $0?.photo }
    }
    
    func unlike(photoWithId id: String) -> Observable<Photo?> {
        return provider.rx
            .request(.unlikePhoto(id: id))
            .asObservable()
            .mapOptional(LikeUnlike.self)
            .map { $0?.photo }
    }
    
    func photo(withId id: String) -> Observable<Photo?> {
        return provider.rx
            .request(.photo(id: id))
            .asObservable()
            .mapOptional(Photo.self)
    }
    
    func photos(byPageNumber pageNumber: Int?, orderBy: OrderBy?, curated: Bool = false) -> Observable<[Photo]?> {
        var photosEnpoint = UnsplashAPI
            .photos(page: pageNumber, 
                    perPage: Constants.photosPerPage, 
                    orderBy: orderBy)
        if curated {
            photosEnpoint = UnsplashAPI
                .curatedPhotos(page: pageNumber, 
                               perPage: Constants.photosPerPage, 
                               orderBy: orderBy)
        }
        return provider.rx
            .request(photosEnpoint)
            .asObservable()
            .mapOptional([Photo].self)
    }
}
