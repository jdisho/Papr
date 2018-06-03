//
//  PhotoService.swift
//  Papr
//
//  Created by Joan Disho on 08.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct PhotoService: PhotoServiceType {

    private var unsplash: MoyaProvider<Unsplash>
    //plugins: [NetworkLoggerPlugin(verbose: false)])

    init(unsplash: MoyaProvider<Unsplash> = MoyaProvider<Unsplash>()) {
        self.unsplash = unsplash
    }

    func like(photo: Photo) ->  Observable<Result<Photo, NonPublicScopeError>> {
        return unsplash.rx
            .request(.likePhoto(id: photo.id ?? ""))
            .map(LikeUnlike.self)
            .map { $0.photo }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { error in
                let accessToken = UserDefaults.standard.string(forKey: UnsplashSettings.clientID.string)
                guard accessToken == nil else {
                    return .just(.error(.error(withMessage: "Failed to like")))
                }
                return .just(.error(.noAccessToken))
            }
    }
    
    func unlike(photo: Photo) ->  Observable<Result<Photo, NonPublicScopeError>> {
        return unsplash.rx
            .request(.unlikePhoto(id: photo.id ?? ""))
            .map(LikeUnlike.self)
            .asObservable()
            .map { $0.photo }
            .unwrap()
            .map(Result.success)
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
            .request(.photo(id: id, width: nil, height: nil, rect: nil))
            .map(Photo.self)
            .asObservable()
    }
    
    func photos(
        byPageNumber pageNumber: Int = 1,
        orderBy: OrderBy = OrderBy.latest,
        curated: Bool = false
        ) -> Observable<Result<[Photo], String>> {


        if curated {
            return unsplash.rx
                    .request(.curatedPhotos(
                        page: pageNumber,
                        perPage: Constants.photosPerPage,
                        orderBy: orderBy
                        )
                    )
                    .map([Photo].self)
                    .asObservable()
                    .map(Result.success)
                    .catchError { error in
                        return .just(.error(error.localizedDescription))
                    }
        }

        return unsplash.rx
            .request(.photos(
                page: pageNumber,
                perPage: Constants.photosPerPage,
                orderBy: orderBy
                )
            )
            .map([Photo].self)
            .asObservable()
            .map(Result.success)
            .catchError { error in
                return .just(.error(error.localizedDescription))
            }
    }

    func statistics(of photo: Photo) -> Observable<PhotoStatistics> {
         return unsplash.rx
            .request(.photoStatistics(
                id: photo.id ?? "",
                resolution: .days,
                quantity: 30)
            )
            .map(PhotoStatistics.self)
            .asObservable()
    }

    func photoDownloadLink(withId id: String) ->  Observable<Result<String, String>> {
        return unsplash.rx
            .request(.photoDownloadLink(id: id))
            .map(Link.self)
            .map { $0.url }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { error in
                return .just(.error("Failed to download photo"))
            }

    }
}
