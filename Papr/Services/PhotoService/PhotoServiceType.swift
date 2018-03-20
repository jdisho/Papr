//
//  PhotoServiceType.swift
//  Papr
//
//  Created by Joan Disho on 08.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

enum LikeUnlikePhotoResult {
    case success(Photo)
    case error(LikeUnlikePhotoError)
}

enum LikeUnlikePhotoError: Error {
    case noAccessToken
    case error(withMessage: String)
}

protocol PhotoServiceType {
    func like(photo: Photo) -> Observable<LikeUnlikePhotoResult>
    func unlike(photo: Photo) -> Observable<LikeUnlikePhotoResult>
    func photo(withId id: String) -> Observable<Photo>
    func photos(byPageNumber pageNumber: Int, orderBy: OrderBy, curated: Bool) -> Observable<[Photo]>
    func statistics(of photo: Photo) -> Observable<PhotoStatistics>
}
