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
    func like(photoWithId id: String) -> Observable<Photo?>
    func unlike(photoWithId id: String) -> Observable<Photo?>
    func photo(withId id: String) -> Observable<Photo?>
    func photos(byPageNumber pageNumber: Int?, orderBy: OrderBy?) -> Observable<[Photo]?>
}
