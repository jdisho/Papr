//
//  SearchPhotosCellModel.swift
//  Papr
//
//  Created by Joan Disho on 27.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchPhotosCellModelInput {
    func updateSize(width: Double, height: Double)
}
protocol SearchPhotosCellModelOutput {
    var smallPhotoURL: Observable<String> { get }
    var regularPhotoURL: Observable<String> { get }
    var photoSize: Observable<(width: Double, height: Double)> { get }
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

    // MARK: Inputs
    func updateSize(width: Double, height: Double) {
        photoSizeProperty.onNext((width: width, height: height))
    }
    
    // MARK: Outputs
    let smallPhotoURL: Observable<String>
    let regularPhotoURL: Observable<String>
    let photoSize: Observable<(width: Double, height: Double)>
    
    // MARK: Privates
    private let photoSizeProperty = BehaviorSubject<(width: Double, height: Double)>(value: (width: 0, height: 0))

    // MARK: Init
    init(photo: Photo) {
        let photoStream = Observable.just(photo)

        smallPhotoURL = photoStream
            .map { $0.urls?.small }
            .unwrap()

        regularPhotoURL = photoStream
            .map { $0.urls?.regular }
            .unwrap()
        
        photoSize = photoSizeProperty.asObservable()
    }
}
