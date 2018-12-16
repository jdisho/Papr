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

enum NavBarTitle {
    case new
    case curated

    var string: String {
        switch self {
        case .new:
            return "Newest 🎉"
        case .curated:
            return "Curated 👌"
        }
    }
}

class HomeViewModel: AutoModel {

    // MARK: Input
    /// sourcery:begin: input
    let loadMore = BehaviorSubject<Bool>(value: false)

    func refresh() {
        refreshProperty.onNext(true)
    }
    
    lazy var showCuratedPhotosAction: CocoaAction = {
        CocoaAction { [unowned self] in
            self.curatedProperty.onNext(true)
            self.refresh()
            return .empty()
        }
    }()
    
    lazy var showLatestPhotosAction: CocoaAction = {
        CocoaAction { [unowned self] in
            self.curatedProperty.onNext(false)
            self.refresh()
            return .empty()
        }
    }()
    
    lazy var orderByPopularityAction: CocoaAction = {
        CocoaAction { [unowned self] in
            self.orderByProperty.onNext(.popular)
            self.refresh()
            return .empty()
        }
    }()

    lazy var orderByFrequencyAction: CocoaAction = {
        CocoaAction { [unowned self] in
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
    /// sourcery:end

    // MARK: Output
    /// sourcery:begin: output
    var photos: Observable<[Photo]>!
    var isRefreshing: Observable<Bool>!
    var curated: Observable<Bool>!
    var orderBy: Observable<OrderBy>!
    var navBarButtonName: Observable<NavBarTitle>!

    lazy var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> = {
        let cachedPhotos = (cache.collection() as Observable<[Photo]>)
        return Observable.combineLatest(photos, cachedPhotos)
            .map { serverPhotos, cachedPhotos -> [HomeViewCellModelType] in
                var homeViewCellModelArray = [HomeViewCellModelType]()
                for (serverPhoto, cachedPhoto) in zip(serverPhotos, cachedPhotos) {
                    let homeViewCellModel = HomeViewCellModel(
                        photo: serverPhoto,
                        likedByUser: cachedPhoto.likedByUser ?? false,
                        totalLikes: cachedPhoto.likes ?? 0
                    )
                    homeViewCellModelArray.append(homeViewCellModel)
                }
                return homeViewCellModelArray
        }
    }()
    /// sourcery:end

    // MARK: Private
    private let cache: Cache
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<OrderBy>(value: .latest)
    private let curatedProperty = BehaviorSubject<Bool>(value: false)
    private let navBarButtonNameProperty = BehaviorSubject<NavBarTitle>(value: .new)

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
        curated = curatedProperty.asObservable()
        orderBy = orderByProperty.asObservable()
        navBarButtonName = navBarButtonNameProperty.asObservable()

        let requestFirst = Observable
            .combineLatest(isRefreshing, orderBy, curated)
            .flatMap { isRefreshing, orderBy, curated -> Observable<[Photo]> in
                guard isRefreshing else { return .empty() }
                return service.photos(
                    byPageNumber: 1,
                    orderBy: orderBy,
                    curated: curated)
                    .flatMap { [unowned self] result -> Observable<[Photo]> in
                        self.navBarButtonNameProperty.onNext(curated ? .curated : .new)
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
            .do (onNext: { _ in
                photoArray = []
                currentPageNumber = 1
            })

        let requestNext = Observable
            .combineLatest(loadMore, orderBy, curated)
            .flatMap { loadMore, orderBy, curated -> Observable<[Photo]> in 
                guard loadMore else { return .empty() }
                currentPageNumber += 1
                return service.photos(
                    byPageNumber: currentPageNumber,
                    orderBy: orderBy,
                    curated: curated)
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
            .map { [unowned self] photos -> [Photo] in
                photos.forEach { photo in
                    photoArray.append(photo)
                }
                self.refreshProperty.onNext(false)
                return photoArray
            }.share(replay: 1)
    }
}
