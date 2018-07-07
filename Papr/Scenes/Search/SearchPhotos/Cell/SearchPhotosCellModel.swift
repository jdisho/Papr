//
//  SearchPhotosCellModel.swift
//  Papr
//
//  Created by Joan Disho on 27.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchPhotosCellModelInput {
    var photoDetailsAction: Action<Photo, Photo> { get }
}
protocol SearchPhotosCellModelOutput {
    var photoStream: Observable<Photo>! { get }
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

    // MARK: Inputs
    
    lazy var photoDetailsAction: Action<Photo, Photo> = {
        return Action<Photo, Photo> { [unowned self] photo in
            let viewModel = PhotoDetailsViewModel(photo: photo)
            self.sceneCoordinator.transition(to: Scene.photoDetails(viewModel))
            return .just(photo)
        }
    }()
    
    // MARK: Outputs
    let photoURL: Observable<String>
    let photoHeight: Observable<Double>
    let sceneCoordinator: SceneCoordinatorType
    var photoStream: Observable<Photo>!

    // MARK: Init
    init(photo: Photo, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.photoStream = Observable.just(photo)
        self.sceneCoordinator = sceneCoordinator

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
