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

protocol SearchPhotosViewModelInput {
    var loadMore: BehaviorSubject<Bool> { get }
}

protocol SearchPhotosViewModelOutput {
    var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> { get }
}

protocol SearchPhotosViewModelType {
    var inputs: SearchPhotosViewModelInput { get }
    var outputs: SearchPhotosViewModelOutput { get }
}

class SearchPhotosViewModel: SearchPhotosViewModelType, SearchPhotosViewModelInput, SearchPhotosViewModelOutput {

    var inputs: SearchPhotosViewModelInput { return self }
    var outputs: SearchPhotosViewModelOutput { return self }

    // MARK: - Inputs
    let loadMore = BehaviorSubject<Bool>(value: false)

    // MARK: - Outputs
    lazy var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> = {
        return photos.mapMany { SearchPhotosCellModel(photo: $0) }
    }()

    // MARK: - Private
    private var photos: Observable<[Photo]>!
    private let service: SearchServiceType
    private let sceneCoordinator: SceneCoordinatorType
    // MARK: - Init

    init(searchQuery: String,
         service: SearchServiceType = SearchService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator

        var currentPageNumber = 1
        var photoArray = [Photo]([])

        let requestFirst = service
            .searchPhotos(with: searchQuery, pageNumber: currentPageNumber)
            .map { $0.results }
            .unwrap()

        let requestNext = loadMore.asObservable()
            .flatMap { loadMore -> Observable<[Photo]> in
                guard loadMore else { return .empty() }
                currentPageNumber += 1
                return service
                    .searchPhotos(with: searchQuery, pageNumber: currentPageNumber)
                    .map { $0.results }
                    .unwrap()
            }

        photos = requestFirst
            .merge(with: requestNext)
            .map { [unowned self] photos -> [Photo] in
                photos.forEach { photo in
                    photoArray.append(photo)
                }
                return photoArray
            }
    }

}
