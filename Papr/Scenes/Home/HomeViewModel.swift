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
    /// Call when the bottom of the list is reached
    var loadMore: BehaviorSubject<Bool> { get }

    /// Call when an OrderBy value is invoked
    var orderByAction: Action<OrderBy, Void> { get }
    
    /// Call when an alert is invoked
    var alertAction: Action<Papr.Error, Void> { get }
    
    /// Call when pull-to-refresh is invoked
    func refresh()
}

protocol HomeViewModelOutput {
    /// Emits an array of photos for the collectionView
    var photos: Observable<[Photo]>! { get }

    /// Emits a boolean when the pull-to-refresh control is refreshing or not.
    var isRefreshing: Observable<Bool>! { get }

    /// Emits an OrderBy value when an OrderBy option is chosen.
    var orderBy: Observable<OrderBy>! { get }

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
    let loadMore = BehaviorSubject<Bool>(value: false)

    func refresh() {
        refreshProperty.onNext(true)
    }
    
    lazy var orderByAction: Action<OrderBy, Void> = {
        Action<OrderBy, Void> { [unowned self] orderBy in
            orderBy == .latest ?
                self.orderByProperty.onNext(.popular) :
                self.orderByProperty.onNext(.latest)
            self.refresh()
            return .empty()
        }
    }()

    lazy var alertAction: Action<Papr.Error, Void> = {
        Action<Papr.Error, Void> { [unowned self] error in
            let alertViewModel = AlertViewModel(
                title: "Upsss...",
                message: error.errorDescription,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()

    // MARK: Output
    var photos: Observable<[Photo]>!
    var isRefreshing: Observable<Bool>!
    var orderBy: Observable<OrderBy>!

    lazy var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> = {
        return Observable.combineLatest(photos, cache.getAllObjects(ofType: Photo.self)).map { photos, cachedPhotos -> [Photo] in
            let cachedPhotos = cachedPhotos.filter { cachedPhoto in
                photos.map { $0.identifier == cachedPhoto.identifier }.contains(true)
            }
            return zip(photos, cachedPhotos).map { photo, cachedPhoto -> Photo in
                var copyPhoto = photo
                copyPhoto.likes = cachedPhoto.likes
                copyPhoto.likedByUser = cachedPhoto.likedByUser
                return copyPhoto
            }
        }
        .mapMany { HomeViewCellModel(photo: $0) }
    }()

    // MARK: Private
    private let cache: Cache
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<OrderBy>(value: .latest)

    // MARK: Init
    init(cache: Cache = Cache.shared,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.cache = cache
        self.service = service
        self.sceneCoordinator = sceneCoordinator

        var currentPageNumber = 1
        var photoArray = [Photo]([])
    
        isRefreshing = refreshProperty.asObservable()
        orderBy = orderByProperty.asObservable()

        let requestFirst = Observable
            .combineLatest(isRefreshing, orderBy)
            .flatMapLatest { isRefreshing, orderBy -> Observable<[Photo]> in
                guard isRefreshing else { return .empty() }
                return service.photos(
                    byPageNumber: 1,
                    orderBy: orderBy)
                    .flatMap { [unowned self] result -> Observable<[Photo]> in
                        switch result {
                        case let .success(photos):
                            return .just(photos)
                        case let .failure(error):
                            self.alertAction.execute(error)
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                    }
            }
            .execute { [unowned self] _ in
                self.refreshProperty.onNext(false)
                photoArray = []
                currentPageNumber = 1
            }

        let requestNext = Observable
            .combineLatest(loadMore, orderBy)
            .flatMapLatest { loadMore, orderBy -> Observable<[Photo]> in
                guard loadMore else { return .empty() }
                currentPageNumber += 1
                return service.photos(
                    byPageNumber: currentPageNumber,
                    orderBy: orderBy)
                    .flatMap { [unowned self] result -> Observable<[Photo]> in
                        switch result {
                        case let .success(photos):
                            return .just(photos)
                        case let .failure(error):
                            self.alertAction.execute(error)
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                    }
            }

        photos = requestFirst
            .merge(with: requestNext)
            .map { photos -> [Photo] in
                photos.forEach { photoArray.append($0) }
                return photoArray
            }
    }
}
