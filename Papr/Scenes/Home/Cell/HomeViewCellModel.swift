//
//  HomeViewCellModel.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol HomeViewCellModelInput {
    var photoDetailsAction: Action<Photo, Photo> { get }
}
protocol HomeViewCellModelOutput {
    var photoStream: Observable<Photo> { get }
    var smallPhoto: Observable<String> { get }
    var regularPhoto: Observable<String> { get }
    var fullPhoto: Observable<String> { get }
    var photoSize: Observable<(Double, Double)> { get }
    var headerViewModelType: HomeViewCellHeaderModelType { get }
}

protocol HomeViewCellModelType {
    var inputs: HomeViewCellModelInput { get }
    var outputs: HomeViewCellModelOutput { get }
}

class HomeViewCellModel: HomeViewCellModelType, HomeViewCellModelInput, HomeViewCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: HomeViewCellModelInput { return self }
    var outputs: HomeViewCellModelOutput { return self }

    // MARK: Inputs
    lazy var photoDetailsAction: Action<Photo, Photo> = {
        Action<Photo, Photo> { [unowned self] photo in
            let viewModel = PhotoDetailsViewModel(photo: photo)
            self.sceneCoordinator.transition(to: Scene.photoDetails(viewModel))
            return .just(photo)
        }
    }()


    // MARK: Output
    let photoStream: Observable<Photo>
    let smallPhoto: Observable<String>
    let regularPhoto: Observable<String>
    let fullPhoto: Observable<String>
    let photoSize: Observable<(Double, Double)>

    lazy var headerViewModelType: HomeViewCellHeaderModelType = {
        return HomeViewCellHeaderModel(photo: photo)
    }()

    // MARK: Private
    private let photo: Photo
    private let photoService: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: Init
    init(photo: Photo,
         photoService: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.photo = photo
        self.photoService = photoService
        self.sceneCoordinator = sceneCoordinator
        
        photoStream = Observable.just(photo)

        smallPhoto = photoStream
            .map { $0.urls?.small }
            .unwrap()

        regularPhoto = photoStream
            .map { $0.urls?.regular }
            .unwrap()

        fullPhoto = photoStream
            .map { $0.urls?.full }
            .unwrap()

        photoSize = Observable.combineLatest(
            photoStream.map { $0.width }.unwrap().map { Double($0) },
            photoStream.map { $0.height }.unwrap().map { Double($0) }
        )
    }
}
