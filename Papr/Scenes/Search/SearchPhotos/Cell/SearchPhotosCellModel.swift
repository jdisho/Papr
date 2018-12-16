//
//  SearchPhotosCellModel.swift
//  Papr
//
//  Created by Joan Disho on 27.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

class SearchPhotosCellModel: AutoModel {

    // MARK: Inputs
    /// sourcery:begin: input
    func updateSize(width: Double, height: Double) {
        photoSizeProperty.onNext((width: width, height: height))
    }
    /// sourcery:end
    
    // MARK: Outputs
    /// sourcery:begin: output
    let smallPhotoURL: Observable<String>
    let regularPhotoURL: Observable<String>
    let photoSize: Observable<(width: Double, height: Double)>
    /// sourcery:end
    
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
