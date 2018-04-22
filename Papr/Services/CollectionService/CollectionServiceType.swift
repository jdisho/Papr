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
    func myCollections() -> Observable<[PhotoCollection]>
    func photos(fromCollectionId id: Int) -> Observable<[Photo]>
    func addPhotoToCollection(withCollectionId id: Int, photoId: String) -> Observable<Void>
}
