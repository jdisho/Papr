//
//  PhotoServiceType.swift
//  Papr
//
//  Created by Joan Disho on 08.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotoServiceType {
    func like(photo: Photo) -> Observable<Result<Photo, Error>>

    func unlike(photo: Photo) -> Observable<Result<Photo, Error>>

    func photo(withId id: String) -> Observable<Photo>

    func photos(byPageNumber pageNumber: Int, orderBy: OrderBy) -> Observable<Result<[Photo], Error>>

    func statistics(of photo: Photo) -> Observable<PhotoStatistics>

    func photoDownloadLink(withId id: String) -> Observable<Result<String, Error>>

    func randomPhotos(from collections: [String], isFeatured: Bool, orientation: Orientation) ->  Observable<[Photo]>

}
