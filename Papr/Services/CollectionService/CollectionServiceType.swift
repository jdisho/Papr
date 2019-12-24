//
//  CollectionServiceType.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol CollectionServiceType {
    func collection(withID id: Int) -> Observable<PhotoCollection>
    
    func collections(withUsername username: String) -> Observable<Result<[PhotoCollection], Papr.Error>>

    func collections(byPageNumber page: Int) -> Observable<Result<[PhotoCollection], Papr.Error>>

    func photos(fromCollectionId id: Int, pageNumber: Int) -> Observable<[Photo]>
    
    func addPhotoToCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Papr.Error>>

    func removePhotoFromCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Papr.Error>>

    func createCollection(with title: String, description: String, isPrivate: Bool) -> Observable<Result<PhotoCollection, Papr.Error>>
}
