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

    /// Call when photos are invoked
    var showPhotosAction: Action<PhotosType, Void> { get }
    
    /// Call when an OrderBy value is invoked
    var orderByAction: Action<OrderBy, Void> { get }
    
    /// Call when an alert is invoked
    var alertAction: Action<String, Void> { get }
    
    /// Call when pull-to-refresh is invoked
    func refresh()
}

protocol HomeViewModelOutput {
    /// Emits an array of photos for the collectionView
    var photos: Observable<[Photo]>! { get }

    /// Emits a boolean when the pull-to-refresh control is refreshing or not.
    var isRefreshing: Observable<Bool>! { get }

    /// Emits a newest or curated photos when the option is chosen.
    var photosType: Observable<PhotosType>! { get }

    /// Emits an OrderBy value when an OrderBy option is chosen.
    var orderBy: Observable<OrderBy>! { get }

    /// Emites the child viewModels
    var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
}

class HomeViewModel: HomeViewModelType, 
                     HomeViewModelInput, 
                     HomeViewModelOutput {

    // MARK: Inputs & Outputs
    var inputs: HomeViewModelInput { return self }
    var outputs: HomeViewModelOutput { return self }

    // MARK: Input
    let loadMore = BehaviorSubject<Bool>(value: false)

    func refresh() {
        refreshProperty.onNext(true)
    }
    
    lazy var showPhotosAction: Action<PhotosType, Void> = {
        Action<PhotosType, Void> { [unowned self] type in
            self.photosTypeProperty.onNext(type)
            self.refresh()
            return .empty()
        }
    }()
    
    lazy var orderByAction: Action<OrderBy, Void> = {
        Action<OrderBy, Void> { [unowned self] orderBy in
            orderBy == .latest ?
                self.orderByProperty.onNext(.popular) :
                self.orderByProperty.onNext(.latest)
            self.refresh()
            return .empty()
        }
    }()

    lazy var alertAction: Action<String, Void> = {
        Action<String, Void> { [unowned self] message in
            let alertViewModel = AlertViewModel(
                title: "Upsss...",
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()

    // MARK: Output
    var photos: Observable<[Photo]>!
    var isRefreshing: Observable<Bool>!
    var photosType: Observable<PhotosType>!
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
    private let photosTypeProperty = BehaviorSubject<PhotosType>(value: .newest)

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
        photosType = photosTypeProperty.asObservable()
        orderBy = orderByProperty.asObservable()

        let requestFirst = Observable
            .combineLatest(isRefreshing, orderBy, photosType.map { $0 == .curated })
            .flatMapLatest { isRefreshing, orderBy, isCurated -> Observable<[Photo]> in
                guard isRefreshing else { return .empty() }
                return service.photos(
                    byPageNumber: 1,
                    orderBy: orderBy,
                    curated: isCurated)
                    .flatMap { [unowned self] result -> Observable<[Photo]> in
                        switch result {
                        case let .success(photos):
                            return .just(photos)
                        case let .error(error):
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
            .combineLatest(loadMore, orderBy, photosType.map { $0 == .curated })
            .flatMapLatest { loadMore, orderBy, isCurated -> Observable<[Photo]> in
                guard loadMore else { return .empty() }
                currentPageNumber += 1
                return service.photos(
                    byPageNumber: currentPageNumber,
                    orderBy: orderBy,
                    curated: isCurated)
                    .flatMap { [unowned self] result -> Observable<[Photo]> in
                        switch result {
                        case let .success(photos):
                            return .just(photos)
                        case let .error(error):
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
