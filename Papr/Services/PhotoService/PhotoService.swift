//
//  PhotoService.swift
//  Papr
//
//  Created by Joan Disho on 08.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct PhotoService: PhotoServiceType {

    private var unsplash: TinyNetworking<Unsplash>
    
    init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>()) {
        self.unsplash = unsplash
    }

    func like(photo: Photo) -> Observable<LikeUnlikePhotoResult> {
        return unsplash.rx
            .request(resource: .likePhoto(id: photo.id ?? ""))
            .map(to: LikeUnlike.self)
            .asObservable()
            .map { $0.photo }
            .unwrap()
            .map(LikeUnlikePhotoResult.success)
            .catchError { error in
                let accessToken = UserDefaults.standard.string(forKey: UnsplashSettings.clientID.string)
                guard accessToken == nil else {
                    return .just(.error(.error(withMessage: "Failed to like")))
                }
                return .just(.error(.noAccessToken))
            }
    }
    
    func unlike(photo: Photo) -> Observable<LikeUnlikePhotoResult> {
        return unsplash.rx
            .request(resource: .unlikePhoto(id: photo.id ?? ""))
            .map(to: LikeUnlike.self)
            .asObservable()
            .map { $0.photo }
            .unwrap()
            .map(LikeUnlikePhotoResult.success)
            .catchError { error in
                let accessToken = UserDefaults.standard.string(forKey: UnsplashSettings.clientID.string)
                guard accessToken == nil else {
                    return .just(.error(.error(withMessage: "Failed to like")))
                }
                return .just(.error(.noAccessToken))
        }
    }
    
    func photo(withId id: String) -> Observable<Photo> {
        return unsplash.rx
            .request(resource: .photo(id: id, width: nil, height: nil, rect: nil))
            .map(to: Photo.self)
            .asObservable()
    }
    
    func photos(
        byPageNumber pageNumber: Int = 1,
        orderBy: OrderBy = OrderBy.latest,
        curated: Bool = false
        ) -> Observable<[Photo]> {


        if curated {
            return unsplash.rx
                    .request(resource: .curatedPhotos(
                        page: pageNumber,
                        perPage: Constants.photosPerPage,
                        orderBy: orderBy
                        )
                    )
                    .map(to: [Photo].self)
                    .asObservable()
        }

        return unsplash.rx
            .request(resource: .photos(
                page: pageNumber,
                perPage: Constants.photosPerPage,
                orderBy: orderBy
                )
            )
            .map(to: [Photo].self)
            .asObservable()
    }

    func statistics(of photo: Photo) -> Observable<PhotoStatistics> {
         return unsplash.rx
            .request(resource: .photoStatistics(
                id: photo.id ?? "",
                resolution: .days,
                quantity: 30)
            )
            .map(to: PhotoStatistics.self)
            .asObservable()
    }
}
