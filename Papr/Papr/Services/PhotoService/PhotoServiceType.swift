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
    func photos(byPageNumber pageNumber: Int?, orderBy: OrderBy?) -> Observable<[Photo]?>
    func like(photoWithId id: String) -> Observable<Photo?>
    func unlike(photoWithId id: String) -> Observable<Photo?>
}
