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

    private let unsplash: TinyNetworking<Unsplash>
    private let cache: Cache

    init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>(),
         cache: Cache = Cache.shared) {
        self.unsplash = unsplash
        self.cache = cache
    }

    func like(photo: Photo) ->  Observable<Result<Photo, Papr.Error>> {
        return unsplash.rx
            .request(resource: .likePhoto(id: photo.id ?? ""))
            .map(to: LikeUnlike.self)
            .map { $0.photo }
            .asObservable()
            .unwrap()
            .execute { self.cache.set(value: $0) }
            .map(Result.success)
            .catchError { _ in
                let accessToken = UserDefaults.standard.string(forKey: Papr.Unsplash.clientID)
                guard accessToken == nil else {
                    return .just(.failure(.other(message: "Failed to like")))
                }
                return .just(.failure(.noAccessToken))
            }
    }
    
    func unlike(photo: Photo) ->  Observable<Result<Photo, Papr.Error>> {
        return unsplash.rx
            .request(resource: .unlikePhoto(id: photo.id ?? ""))
            .map(to: LikeUnlike.self)
            .map { $0.photo }
            .asObservable()
            .unwrap()
            .execute { self.cache.set(value: $0) } // 🎡 Update cache
            .map(Result.success)
            .catchError { _ in
                let accessToken = UserDefaults.standard.string(forKey: Papr.Unsplash.clientID)
                guard accessToken == nil else {
                    return .just(.failure(.other(message: "Failed to unlike")))
                }
                return .just(.failure(.noAccessToken))
        }
    }
    
    func photo(withId id: String) -> Observable<Photo> {
        return unsplash.rx
            .request(resource: .photo(id: id, width: nil, height: nil, rect: nil))
            .map(to: Photo.self)
            .asObservable()
    }
    
    func photos(
        byPageNumber pageNumber: Int? = nil,
        orderBy: OrderBy? = nil
        ) -> Observable<Result<[Photo], Papr.Error>> {

        let photos: Unsplash = .photos(page: pageNumber, perPage: nil, orderBy: orderBy)
        
        return unsplash.rx.request(resource: photos)
            .map(to: [Photo].self)
            .asObservable()
            .execute { self.cache.set(values: $0) }  // 👨‍👩‍👧‍👧 Populate the cache.
            .map(Result.success)
            .catchError { .just(.failure(.other(message: $0.localizedDescription))) }
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

    func photoDownloadLink(withId id: String) ->  Observable<Result<String, Papr.Error>> {
        return unsplash.rx
            .request(resource: .photoDownloadLink(id: id))
            .map(to: Link.self)
            .map { $0.url }
            .asObservable()
            .unwrap()
            .map(Result.success)
            .catchError { _ in return .just(.failure(.other(message: "Failed to download photo"))) }

    }

    func randomPhotos(from collections: [String], isFeatured: Bool, orientation: Orientation) -> Observable<[Photo]> {
        return unsplash.rx.request(resource: .randomPhoto(
                collections: collections,
                isFeatured: isFeatured,
                username: nil,
                query: nil,
                width: nil,
                height: nil,
                orientation: orientation,
                count: 30)
            )
            .map(to: [Photo].self)
            .asObservable()
    }
}
