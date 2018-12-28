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
    var photoSize: Observable<(Double, Double)> { get }
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
    let photoSize: Observable<(Double, Double)>

    // MARK: Init
    init(photo: Photo) {
        let photoStream = Observable.just(photo)

        smallPhotoURL = photoStream
            .map { $0.urls?.small }
            .unwrap()

        regularPhotoURL = photoStream
            .map { $0.urls?.regular }
            .unwrap()
        
        photoSize = Observable.combineLatest(
            photoStream.map { $0.width }.unwrap().map { Double($0) },
            photoStream.map { $0.height }.unwrap().map { Double($0) }
        )
    }
}
