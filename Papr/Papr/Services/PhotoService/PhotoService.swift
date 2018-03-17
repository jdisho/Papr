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

    private var unsplash: Unsplash
    
    init(unsplash: Unsplash = Unsplash()) {
        self.unsplash = unsplash
    }

    func like(photo: Photo) -> Observable<LikeUnlikePhotoResult> {
        let resource = Resource<Photo, LikeUnlike>(
            url: UnsplashAPI.likePhoto(id: photo.id ?? "").path,
            method: .post(photo))

        return unsplash.request(resource)
            .asObservable()
            .map { $0.photo }
            .unwrap()
            .map(LikeUnlikePhotoResult.success)
            .catchError { _ in .just(.error(withMessage: "Failed to like the photo")) }
    }
    
    func unlike(photo: Photo) -> Observable<LikeUnlikePhotoResult> {
        let resource = SimpleResource<LikeUnlike>(
            url: UnsplashAPI.unlikePhoto(id: photo.id ?? "").path,
            method: .delete)

        return unsplash.request(resource)
            .asObservable()
            .map { $0.photo }
            .unwrap()
            .map(LikeUnlikePhotoResult.success)
            .catchError { _ in .just(.error(withMessage: "Failed to unlike the photo")) }
    }
    
    func photo(withId id: String) -> Observable<Photo> {
        let resource = SimpleResource<Photo>(url: UnsplashAPI.photo(id: id).path)
        return unsplash.request(resource).asObservable()
    }
    
    func photos(
        byPageNumber pageNumber: Int = 1,
        orderBy: OrderBy = OrderBy.latest,
        curated: Bool = false
        ) -> Observable<[Photo]> {

        var endPoint = UnsplashAPI.photos(
            page: pageNumber,
            perPage: Constants.photosPerPage,
            orderBy: orderBy
            ).path

        if curated {
            endPoint = UnsplashAPI.curatedPhotos(
                page: pageNumber,
                perPage: Constants.photosPerPage,
                orderBy: orderBy
                ).path
        }

        var params: [String: String] = [:]
        params["page"] = "\(pageNumber)"
        params["per_page"] = "\(Constants.photosPerPage)"
        params["order_by"] = orderBy.string

        let resource = SimpleResource<[Photo]>(url: endPoint, parameters: params)
        return unsplash.request(resource).asObservable()
    }

    func statistics(of photo: Photo) -> Observable<PhotoStatistics> {
        let endPoint = UnsplashAPI.photoStatistics(
            id: photo.id ?? "",
            resolution: .days,
            quantity: 30
            ).path
        let resource = SimpleResource<PhotoStatistics>(url: endPoint)
        return unsplash.request(resource).asObservable()
    }
}
