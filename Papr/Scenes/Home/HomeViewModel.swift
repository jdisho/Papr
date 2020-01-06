//
//  HomeViewModel.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol HomeViewModelInput {
    /// Call when the pull-to-refresh is invoked
    var refreshProperty: BehaviorSubject<Bool> { get }
    
    /// Call when the bottom of the list is reached
    var loadMoreProperty: BehaviorSubject<Bool> { get }

    /// Call when an OrderBy value is invoked
    var orderByProperty: BehaviorSubject<OrderBy> { get }
}

protocol HomeViewModelOutput {
    /// Emits a boolean when the pull-to-refresh control is refreshing or not.
    var isRefreshing: Observable<Bool> { get }
    
    /// Emits a boolean when the content is loading or not.
    var isLoadingMore: Observable<Bool> { get }
    
    /// Emits an OrderBy value when an OrderBy option is chosen
    var isOrderBy: Observable<OrderBy> { get }
    
    /// Emits a boolean  when the first page is requested
    var isFirstPageRequested: Observable<Bool> { get }

    /// Emites the child viewModels
    var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
}

final class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {

    // MARK: Inputs & Outputs
    var inputs: HomeViewModelInput { return self }
    var outputs: HomeViewModelOutput { return self }

    // MARK: Input
    let refreshProperty = BehaviorSubject<Bool>(value: true)
    let loadMoreProperty = BehaviorSubject<Bool>(value: false)
    let orderByProperty = BehaviorSubject<OrderBy>(value: .latest)

    // MARK: Output
    let isRefreshing: Observable<Bool>
    let isLoadingMore: Observable<Bool>
    let isOrderBy: Observable<OrderBy>
    let isFirstPageRequested: Observable<Bool>
    let homeViewCellModelTypes: Observable<[HomeViewCellModelType]>

    // MARK: Private
    private let cache: Cache
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: Init
    init(cache: Cache = Cache.shared,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.cache = cache
        self.service = service
        self.sceneCoordinator = sceneCoordinator

        var currentPageNumber = 1
        var photoArray = [Photo]([])

        let firstResult = Observable
            .combineLatest(refreshProperty, orderByProperty)
            .flatMapLatest { isRefreshing, orderBy -> Observable<Result<[Photo], Papr.Error>> in
                guard isRefreshing else { return .empty() }
                return service.photos(byPageNumber: nil, orderBy: orderBy)
            }
            .execute { _ in
                photoArray = []
                currentPageNumber = 1
            }
            .share()

        let nextResult = Observable
            .combineLatest(loadMoreProperty, orderByProperty)
            .flatMapLatest { isLoadingMore, orderBy -> Observable<Result<[Photo], Papr.Error>> in
                guard isLoadingMore else { return .empty() }
                currentPageNumber += 1
                return service.photos(byPageNumber: currentPageNumber, orderBy: orderBy)
            }
            .share()

        let requestedPhotos = firstResult
            .merge(with: nextResult)
            .map { result -> [Photo]? in
                switch result {
                case let .success(photos):
                    return photos
                case let .failure(error):
                    let alertViewModel = AlertViewModel(
                        title: "Upsss...",
                        message: error.errorDescription,
                        mode: .ok)
                    sceneCoordinator.transition(to: Scene.alert(alertViewModel))
                    return nil
                }
            }
            .unwrap()
            .map { photos -> [Photo] in
                photos.forEach { photoArray.append($0) }
                return photoArray
            }
        
        isRefreshing = refreshProperty
        isLoadingMore = loadMoreProperty
        isOrderBy = orderByProperty
        isFirstPageRequested = firstResult.map(to: true)
        
        homeViewCellModelTypes = Observable.combineLatest(requestedPhotos, cache.getAllObjects(ofType: Photo.self))
            .map { photos, cachedPhotos -> [Photo] in
                let cachedPhotos = cachedPhotos.filter { photos.contains($0) }
                return zip(photos, cachedPhotos).map { photo, cachedPhoto -> Photo in
                    var photo = photo
                    photo.likes = cachedPhoto.likes
                    photo.likedByUser = cachedPhoto.likedByUser
                    return photo
                }
            }
            .mapMany { HomeViewCellModel(photo: $0) }
    }
}
