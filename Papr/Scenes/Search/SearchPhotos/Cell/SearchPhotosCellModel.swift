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
    var photoStream: Observable<Photo> { get }
    var smallPhotoURL: Observable<URL> { get }
    var regularPhotoURL: Observable<URL> { get }
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
    let photoStream: Observable<Photo>
    let smallPhotoURL: Observable<URL>
    let regularPhotoURL: Observable<URL>
    let photoSize: Observable<(Double, Double)>

    // MARK: Init
    init(photo: Photo) {
        photoStream = Observable.just(photo)
        
        smallPhotoURL = photoStream
            .map { $0.urls?.small }
            .unwrap()
            .mapToURL()
        
        regularPhotoURL = photoStream
            .map { $0.urls?.regular }
            .unwrap()
            .mapToURL()

        photoSize = Observable.combineLatest(
            photoStream.map { $0.width }.unwrap().map { Double($0) },
            photoStream.map { $0.height }.unwrap().map { Double($0) }
        )
    }
}
