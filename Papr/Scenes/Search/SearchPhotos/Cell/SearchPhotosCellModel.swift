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
    var smallPhotoURL: Observable<String> { get }
    var regularPhotoURL: Observable<String> { get }
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
    let smallPhotoURL: Observable<String>
    let regularPhotoURL: Observable<String>
    let fullPhotoURL: Observable<String>
    let rawPhotoURL: Observable<String>

    // MARK: Init
    init(photo: Photo) {
        let photoStream = Observable.just(photo)

        smallPhotoURL = photoStream
            .map { $0.urls?.small }
            .unwrap()

        regularPhotoURL = photoStream
            .map { $0.urls?.regular }
            .unwrap()
    }
}
