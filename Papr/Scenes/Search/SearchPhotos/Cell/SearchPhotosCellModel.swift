//
//  SearchPhotosCellModel.swift
//  Papr
//
//  Created by Joan Disho on 27.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchPhotosCellModelInput {}
protocol SearchPhotosCellModelOutput {
    var photo: Observable<Photo> { get }
    var photoSize: Observable<(Double, Double)> { get }
}

protocol SearchPhotosCellModelType {
    var inputs: SearchPhotosCellModelInput { get }
    var outputs: SearchPhotosCellModelOutput { get }
}

final class SearchPhotosCellModel: SearchPhotosCellModelType,
                            SearchPhotosCellModelInput,
                            SearchPhotosCellModelOutput {
    
    // MARK: Inputs & Outputs
    var inputs: SearchPhotosCellModelInput { return self }
    var outputs: SearchPhotosCellModelOutput { return self }

    // MARK: Outputs
    let photo: Observable<Photo>
    let photoSize: Observable<(Double, Double)>

    // MARK: Init
    init(photo: Photo) {
        self.photo = Observable.just(photo)

        photoSize = Observable.combineLatest(
            self.photo.map { $0.width }.unwrap().map { Double($0) },
            self.photo.map { $0.height }.unwrap().map { Double($0) }
        )
    }
}
