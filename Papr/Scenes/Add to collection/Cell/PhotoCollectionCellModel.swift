//
//  PhotoCollectionCellModel.swift
//  Papr
//
//  Created by Joan Disho on 22.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotoCollectionCellModelInput {

}

protocol PhotoCollectionCellModelOutput {

}


protocol PhotoCollectionCellModelType {
    var inputs: PhotoCollectionCellModelInput { get }
    var outputs: PhotoCollectionCellModelOutput { get }
}

class PhotoCollectionCellModel: PhotoCollectionCellModelInput,
                                PhotoCollectionCellModelOutput,
                                PhotoCollectionCellModelType {


    // MARK: Inputs & Outputs
    var inputs: PhotoCollectionCellModelInput { return self }
    var outputs: PhotoCollectionCellModelOutput { return self }

    // MARK: Inputs


    // MARK: Outputs
    private let photoCollection: PhotoCollection

    init(photoCollection: PhotoCollection) {
        self.photoCollection = photoCollection
    }

}
