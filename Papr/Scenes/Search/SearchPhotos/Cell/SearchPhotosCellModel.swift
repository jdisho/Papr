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
    var photoURL: Observable<String> { get }
    var photoHeight: Observable<Double> { get }
}

protocol SearchPhotosCellModelType {
    var inputs: SearchPhotosCellModelInput { get }
    var outputs: SearchPhotosCellModelOutput { get }
}

class SearchPhotosCellModel: SearchPhotosCellModelType,
                            SearchPhotosCellModelInput,
                            SearchPhotosCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: SearchPhotosCellModelInput { return self }
    var outputs: SearchPhotosCellModelOutput { return self }

    // MARK: Outputs
    let photoURL: Observable<String>
    let photoHeight: Observable<Double>

    // MARK: Init
    init(photo: Photo) {
        let photoStream = Observable.just(photo)

        photoURL = photoStream
            .map { $0.urls?.small }
            .unwrap()

        photoHeight = photoStream
            .map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                Double(height * Int(UIScreen.main.bounds.width) / width)
        }
    }
}
