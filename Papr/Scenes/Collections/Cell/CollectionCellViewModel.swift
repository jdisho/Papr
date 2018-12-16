//
//  CollectionCellViewModel.swift
//  Papr
//
//  Created by Joan Disho on 05.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

class CollectionCellViewModel: AutoModel {

    // MARK: Input

    // MARK: Output
    /// sourcery:begin: output
    let photoCollection: Observable<PhotoCollection>
    /// sourcery:end

    // MARK: Private

    // MARK: Init
    init(photoCollection: PhotoCollection) {
        self.photoCollection = Observable.just(photoCollection)
    }
}
