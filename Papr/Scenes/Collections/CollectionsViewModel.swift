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

protocol CollectionsViewModelInput {
    /// Call when the bottom of the list is reached
    var loadMore: BehaviorSubject<Bool> { get }

    /// Call when pull-to-refresh is invoked
    func refresh()

     /// Call when a collection is selected
    var collectionDetailsAction: Action<PhotoCollection, Void> { get }
}
protocol CollectionsViewModelOutput {
    /// Emits a boolean when the pull-to-refresh control is refreshing or not.
    var isRefreshing: Observable<Bool>! { get }

    /// Emites the child viewModels
    var collectionCellsModelType: Observable<[CollectionCellViewModelType]> { get }
}
protocol CollectionsViewModelType {
    var input: CollectionsViewModelInput { get }
    var output: CollectionsViewModelOutput { get }
}

final class CollectionsViewModel: CollectionsViewModelType,
                            CollectionsViewModelInput,
                            CollectionsViewModelOutput {
    // MARK: Inputs & Outputs
    var input: CollectionsViewModelInput { return self }
    var output: CollectionsViewModelOutput { return self }

    // MARK: Inputs
    let loadMore = BehaviorSubject<Bool>(value: false)

    func refresh() {
        refreshProperty.onNext(true)
    }

    // MARK: Outputs
    var isRefreshing: Observable<Bool>!

    lazy var collectionCellsModelType: Observable<[CollectionCellViewModelType]> = {
        return photoCollections.mapMany { CollectionCellViewModel(photoCollection: $0) }
    }()

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
                    .collections(byPageNumber: 1)
                    .flatMap { [unowned self] result -> Observable<[PhotoCollection]> in
                        switch result {
                        case let .success(photoCollections):
                            return .just(photoCollections)
                        case .failure(_):
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
                    .collections(byPageNumber: currentPageNumber)
                    .flatMap { [unowned self] result -> Observable<[PhotoCollection]> in
                        switch result {
                        case let .success(photoCollections):
                            return .just(photoCollections)
                        case .failure(_):
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
