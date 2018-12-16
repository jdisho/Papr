//
//  CollectionsViewModel.swift
//  Papr
//
//  Created by Joan Disho on 04.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

class CollectionsViewModel: AutoModel {
  
    // MARK: Inputs
    /// sourcery:begin: input
    let loadMore = BehaviorSubject<Bool>(value: false)
  
    func refresh() {
        refreshProperty.onNext(true)
    }
    
    lazy var collectionDetailsAction: Action<PhotoCollection, Void> = {
        return Action<PhotoCollection, Void> { [unowned self] collection in
            let viewModel = SearchPhotosViewModel(type:
                .collectionPhotos(
                    title: collection.title ?? "",
                    collectionID: collection.id ?? 0,
                    collectionService: CollectionService()
                )
            )
            return self.sceneCoordinator.transition(to: Scene.searchPhotos(viewModel))
        }
    }()
    /// sourcery:end

    // MARK: Outputs
    /// sourcery:begin: output
    var isRefreshing: Observable<Bool>!

    lazy var collectionCellsModelType: Observable<[CollectionCellViewModelType]> = {
        return photoCollections.mapMany { CollectionCellViewModel(photoCollection: $0) }
    }()
    /// sourcery:end

    // MARK: Private
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private var photoCollections: Observable<[PhotoCollection]>!
    private let refreshProperty = BehaviorSubject<Bool>(value: true)

    // MARK: Init
    init(service: CollectionServiceType = CollectionService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator

        var currentPageNumber = 1
        var collectionArray = [PhotoCollection]([])

        isRefreshing = refreshProperty.asObservable()

        let requestFirst = isRefreshing
            .flatMapLatest { isRefreshing -> Observable<[PhotoCollection]> in
                guard isRefreshing else { return .empty() }
                return service
                    .collections(byPageNumber: 1, curated: false)
                    .flatMap { [unowned self] result -> Observable<[PhotoCollection]> in
                        switch result {
                        case let .success(photoCollections):
                            return .just(photoCollections)
                        case .error(_):
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                }
            }
            .do (onNext: { _ in
                collectionArray = []
                currentPageNumber = 1
            })

        let requestNext = loadMore.asObservable()
            .flatMapLatest { isLoadingMore -> Observable<[PhotoCollection]> in
                guard isLoadingMore else { return .empty() }
                currentPageNumber += 1
                return service
                    .collections(byPageNumber: currentPageNumber, curated: false)
                    .flatMap { [unowned self] result -> Observable<[PhotoCollection]> in
                        switch result {
                        case let .success(photoCollections):
                            return .just(photoCollections)
                        case .error(_):
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                }
            }

        photoCollections = requestFirst
            .merge(with: requestNext)
            .map { [unowned self] collections -> [PhotoCollection] in
                collections.forEach { collection in
                    collectionArray.append(collection)
                }
                self.refreshProperty.onNext(false)
                return collectionArray
        }
    }
}
