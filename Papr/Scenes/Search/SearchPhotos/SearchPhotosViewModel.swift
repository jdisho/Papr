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

class SearchPhotosViewModel: AutoModel {

    enum SearchType {
        case collectionPhotos(title: String, collectionID: Int, collectionService: CollectionServiceType)
        case searchPhotos(searchQuery: String, searchService: SearchServiceType)
    }

    // MARK: - Inputs
    /// sourcery:begin: input
    let loadMore = BehaviorSubject<Bool>(value: false)
    /// sourcery:end

    // MARK: - Outputs
    /// sourcery:begin: output
    let navTitle: Observable<String>
    lazy var searchPhotosCellModelType: Observable<[SearchPhotosCellModelType]> = {
        return photos.mapMany { SearchPhotosCellModel(photo: $0) }
    }()
    /// sourcery:end

    // MARK: - Private
    private var photos: Observable<[Photo]>!
    private let sceneCoordinator: SceneCoordinatorType
    // MARK: - Init

    init(type: SearchType, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

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
                .flatMap { loadMore -> Observable<[Photo]> in
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
                .flatMap { loadMore -> Observable<[Photo]> in
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
