//
//  CollectionServiceType.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

enum NonPublicScopeError {
    case noAccessToken
    case error(withMessage: String)
}

protocol CollectionServiceType {
    func collections(withUsername username: String,byPageNumber pageNumber: Int) -> Observable<Result<[PhotoCollection], String>>

    func photos(fromCollectionId id: Int) -> Observable<[Photo]>
    
    func addPhotoToCollection(withCollectionId id: Int, photoId: String) -> Observable<Result<PhotoCollection, String>>
}
