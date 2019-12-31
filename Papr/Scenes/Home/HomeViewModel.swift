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
    var isRefreshing: Observable<Bool>!
    var orderBy: Observable<OrderBy>!

    lazy var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> = {
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
            .mapMany { HomeViewCellModel(photo: $0) }
    }()

    // MARK: Private
    private let cache: Cache
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<OrderBy>(value: .latest)
    private var photos: Observable<[Photo]>!

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
            .flatMapLatest { isRefreshing, orderBy -> Observable<Result<[Photo], Papr.Error>> in
                guard isRefreshing else { return .empty() }
                return service.photos(byPageNumber: 1, orderBy: orderBy)
            }
            .execute { [weak self] _ in
                photoArray = []
                currentPageNumber = 1
                self?.refreshProperty.onNext(false)
            }

        let requestNext = Observable
            .combineLatest(loadMore, orderBy)
            .flatMapLatest { isLoading, orderBy -> Observable<Result<[Photo], Papr.Error>> in
                guard isLoading else { return .empty() }
                currentPageNumber += 1
                return service.photos(byPageNumber: currentPageNumber, orderBy: orderBy)
            }

        photos = requestFirst
            .merge(with: requestNext)
            .map { [weak self] result -> [Photo]? in
                switch result {
                case let .success(photos):
                    return photos
                case let .failure(error):
                    self?.alertAction.execute(error)
                    self?.refreshProperty.onNext(false)
                    return nil
                }
            }
            .unwrap()
            .map { photos -> [Photo] in
                photos.forEach { photoArray.append($0) }
                return photoArray
            }
    }
}
