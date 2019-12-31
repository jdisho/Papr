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
    var photoDetailsAction: Action<Photo, Void> { get }
}

protocol SearchPhotosViewModelOutput {
    var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> { get }
    var navTitle: Observable<String> { get }
}

protocol SearchPhotosViewModelType {
    var inputs: SearchPhotosViewModelInput { get }
    var outputs: SearchPhotosViewModelOutput { get }
}

final class SearchPhotosViewModel: SearchPhotosViewModelType, SearchPhotosViewModelInput, SearchPhotosViewModelOutput {

    var inputs: SearchPhotosViewModelInput { return self }
    var outputs: SearchPhotosViewModelOutput { return self }

    enum SearchType {
        case collectionPhotos(title: String, collectionID: Int, collectionService: CollectionServiceType)
        case searchPhotos(searchQuery: String, searchService: SearchServiceType)
    }

    // MARK: - Inputs
    let loadMore = BehaviorSubject<Bool>(value: false)

    lazy var photoDetailsAction: Action<Photo, Void> = {
        return Action<Photo, Void> { [unowned self] photo in
            let viewModel = PhotoDetailsViewModel(photo: photo)
            return self.sceneCoordinator.transition(to: Scene.photoDetails(viewModel))
        }
    }()

    // MARK: - Outputs
    let navTitle: Observable<String>
    lazy var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> = {
        return Observable.combineLatest(photos, cache.getAllObjects(ofType: Photo.self))
            .map { photos, cachedPhotos -> [Photo] in
                let cachedPhotos = cachedPhotos.filter { photos.contains($0) }
                return zip(photos, cachedPhotos).map { photo, cachedPhoto -> Photo in
                    var photo = photo
                    photo.likes = cachedPhoto.likes
                    photo.likedByUser = cachedPhoto.likedByUser
                    return photo
                }
            }
            .mapMany { SearchPhotosCellModel(photo: $0) }
    }()

    // MARK: - Private
    private var photos: Observable<[Photo]>!
    private let cache: Cache
    private let sceneCoordinator: SceneCoordinatorType
    // MARK: - Init

    init(type: SearchType,
         cache: Cache = .shared,
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.cache = cache
        self.sceneCoordinator = sceneCoordinator

        var photoArray = [Photo]([])
        var currentPageNumber = 1
        let requestFirst: Observable<[Photo]>
        let requestNext: Observable<[Photo]>

        switch type {
        case let .searchPhotos(searchQuery: searchQuery, searchService: searchService):

            let searchResultsNumber = searchService
                .searchPhotos(with: searchQuery, pageNumber: currentPageNumber)
                .map { $0.total }
                .unwrap()

            requestFirst = searchService
                .searchPhotos(with: searchQuery, pageNumber: 1)
                .map { $0.results }
                .unwrap()

            requestNext = loadMore.asObservable()
                .flatMapLatest { loadMore -> Observable<[Photo]> in
                    guard loadMore else { return .empty() }
                    currentPageNumber += 1
                    return searchService
                        .searchPhotos(with: searchQuery, pageNumber: currentPageNumber)
                        .map { $0.results }
                        .unwrap()
            }

            navTitle =  Observable.zip(Observable.just(searchQuery), searchResultsNumber)
                .map { query, resultsNumber in
                    return "\(query): \(resultsNumber) results"
            }

        case let .collectionPhotos(title: title, collectionID: collectionID, collectionService: collectionService):
            
            requestFirst = collectionService.photos(fromCollectionId: collectionID, pageNumber: 1)

            requestNext = loadMore.asObservable()
                .flatMapLatest { loadMore -> Observable<[Photo]> in
                    guard loadMore else { return .empty() }
                    currentPageNumber += 1
                    return collectionService.photos(fromCollectionId: collectionID, pageNumber: currentPageNumber)
            }

            navTitle = Observable.just(title)

        }

        photos = requestFirst
            .merge(with: requestNext)
            .map { photos -> [Photo] in
                photos.forEach { photo in
                    photoArray.append(photo)
                }
                return photoArray
            }
    }

}
