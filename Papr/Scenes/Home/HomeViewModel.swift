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

protocol HomeViewModelInput {
    /// Call when the bottom of the list is reached
    var loadMore: BehaviorSubject<Bool> { get }

    /// Call when show-curated-photos is invoked
    var showCuratedPhotosAction: CocoaAction { get }
    
    /// Call when show-lastest-photos is invoked
    var showLatestPhotosAction: CocoaAction { get }
    
    /// Call when OrderBy-Popular is invoked
    var orderByPopularityAction: CocoaAction { get }
    
    /// Call when OrderBy-Latest is invoked
    var orderByFrequencyAction: CocoaAction { get }
    
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

    /// Emits a boolean when the Curated option is chosen.
    var curated: Observable<Bool>! { get }

    /// Emits an OrderBy value when an OrderBy option is chosen.
    var orderBy: Observable<OrderBy>! { get }
    
     /// Emits the name of the navigation bar value when an OrderBy/Curated option is choosen.
    var navBarButtonName: Observable<NavBarTitle>! { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
    func createHomeViewCellModel(for photo: Photo) -> HomeViewCellModel
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
            return self.sceneCoordinator.transition(
                to: .alert(alertViewModel),
                type: .alert)
        }
    }()


    // MARK: Output
    var photos: Observable<[Photo]>!
    var isRefreshing: Observable<Bool>!
    var curated: Observable<Bool>!
    var orderBy: Observable<OrderBy>!
    var navBarButtonName: Observable<NavBarTitle>!

    func createHomeViewCellModel(for photo: Photo) -> HomeViewCellModel {
        return HomeViewCellModel(photo: photo)
    }

    // MARK: Private
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<OrderBy>(value: .latest)
    private let curatedProperty = BehaviorSubject<Bool>(value: false)
    private let navBarButtonNameProperty = BehaviorSubject<NavBarTitle>(value: .new)

    // MARK: Init
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, 
         service: PhotoServiceType = PhotoService()) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service

        var currentPageNumber = 1
        var photoArray = [Photo]([])
    
        isRefreshing = refreshProperty.asObservable()
        curated = curatedProperty.asObservable()
        orderBy = orderByProperty.asObservable()
        navBarButtonName = navBarButtonNameProperty.asObservable()

        let requestFirst = Observable
            .combineLatest(isRefreshing, orderBy, curated)
            .flatMapLatest { isRefreshing, orderBy, curated -> Observable<[Photo]> in
                guard isRefreshing else { return .empty() }
                return service
                    .photos(byPageNumber: 1,
                            orderBy: orderBy, 
                            curated: curated)
                    .map { [unowned self] photos in 
                        self.navBarButtonNameProperty.onNext(curated ? .curated : .new)
                        return photos
                    }
            }
            .do (onNext: { _ in
                photoArray = []
                currentPageNumber = 1
            })

        let requestNext = Observable
            .combineLatest(loadMore, orderBy, curated)
            .flatMapLatest { loadMore, orderBy, curated -> Observable<[Photo]> in 
                guard loadMore else { return .empty() }
                currentPageNumber += 1
                return service.photos(
                    byPageNumber: currentPageNumber,
                    orderBy: orderBy,
                    curated: curated)
            }

         photos = Observable
            .merge(requestFirst, requestNext)
            .map { [unowned self] photos -> [Photo] in
                photos.forEach { photo in 
                    photoArray.append(photo)
                }
                self.refreshProperty.onNext(false)
                return photoArray
            }
            .catchError({ [unowned self] error in
                self.alertAction.execute(error.localizedDescription)
                self.refreshProperty.onNext(false)
                return Observable.just(photoArray)
            })
    }
}


