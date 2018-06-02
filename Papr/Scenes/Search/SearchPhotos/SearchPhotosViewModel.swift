//  
//  SearchPhotosViewModel.swift
//  Papr
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchPhotosViewModelInput {}

protocol SearchPhotosViewModelOutput {
    var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> { get }
    var photosHeight: Observable<[Double]> { get }
}

protocol SearchPhotosViewModelType {
    var inputs: SearchPhotosViewModelInput { get }
    var outputs: SearchPhotosViewModelOutput { get }
}

class SearchPhotosViewModel: SearchPhotosViewModelType, SearchPhotosViewModelInput, SearchPhotosViewModelOutput {

    var inputs: SearchPhotosViewModelInput { return self }
    var outputs: SearchPhotosViewModelOutput { return self }

    // MARK: - Inputs

    // MARK: - Outputs
    lazy var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> = {
        return photos.mapMany { SearchPhotosCellModel(photo: $0) }
    }()

    lazy var photosHeight: Observable<[Double]> = {
        return searchPhotosCellModelType
            .mapMany { $0.outputs.photoHeight }
            .flatMap(Observable.combineLatest)
    }()

    // MARK: - Private
    private let photos: Observable<[Photo]>
    private let service: SearchServiceType
    private let sceneCoordinator: SceneCoordinatorType
    // MARK: - Init

    init(searchQuery: String,
         service: SearchServiceType = SearchService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator

        photos = service.searchPhotos(with: searchQuery, pageNumber: 1)
            .map { $0.results }
            .unwrap()
    }

}
