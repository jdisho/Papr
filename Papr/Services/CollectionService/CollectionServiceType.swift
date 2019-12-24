//
//  CollectionServiceType.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

enum Error: LocalizedError {
    case noAccessToken
    case other(message: String)

    var errorDescription: String {
        switch self {
        case .noAccessToken:
            return "Please provide the access token."
        case let .other(message: message):
            return message
        }
    }
}

protocol CollectionServiceType {
    func collection(withID id: Int) -> Observable<PhotoCollection>
    
    func collections(withUsername username: String) -> Observable<Result<[PhotoCollection], Error>>

    func collections(byPageNumber page: Int) -> Observable<Result<[PhotoCollection], Error>>

    func photos(fromCollectionId id: Int, pageNumber: Int) -> Observable<[Photo]>
    
    func addPhotoToCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Error>>

    func removePhotoFromCollection(withId id: Int, photoId: String) -> Observable<Result<Photo, Error>>

    func createCollection(with title: String, description: String, isPrivate: Bool) -> Observable<Result<PhotoCollection, Error>>
}
