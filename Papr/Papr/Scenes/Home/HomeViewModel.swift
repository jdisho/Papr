//
//  HomeViewModel.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

protocol HomeViewModelInput {
    /// Call when pull-to-refresh is invoked
    func refresh()
    
    /// Call when the bottom of the list is reached
    var loadMore: BehaviorRelay<Bool> { get }
    
    /// Call when an option of OrderBy is chosen
    var orderBy: BehaviorRelay<OrderBy> { get }
}

protocol HomeViewModelOutput {
    /// Emits an array of photos for the collectionView
    var photos: Observable<[Photo]>! { get }
    
    /// Emits when the pull-to-refresh control is refreshing or not.
    var isRefreshing: Observable<Bool>! { get }
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
    let loadMore = BehaviorRelay<Bool>(value: false)
    let orderBy = BehaviorRelay<OrderBy>(value: .latest)
    let refreshProperty = BehaviorRelay<Bool>(value: true)

    func refresh() {
        refreshProperty.accept(true)
    }

    // MARK: Output
    var photos: Observable<[Photo]>!
    var isRefreshing: Observable<Bool>!

    func createHomeViewCellModel(for photo: Photo) -> HomeViewCellModel {
        return HomeViewCellModel(photo: photo)
    }

    // MARK: Private
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: Init
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, 
         service: PhotoServiceType = PhotoService()) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service

        var currentPageNumber = 1
        var photoArray = [Photo]([])
    
        isRefreshing = refreshProperty.asObservable()

        let requestFirst = Observable
            .combineLatest(refreshProperty, orderBy)
            .flatMap { isRefreshing, orderBy -> Observable<[Photo]?> in
                guard isRefreshing else { 
                    return .empty()
                }
                return service.photos(byPageNumber: 1, orderBy: orderBy)
            }
            .do (onNext: { [unowned self] _ in 
                photoArray = []
                currentPageNumber = 1
                self.refreshProperty.accept(false) 
            })

        let requestNext = Observable
            .combineLatest(loadMore, orderBy)
            .flatMap { loadMore, orderBy -> Observable<[Photo]?> in 
                guard loadMore else { return .empty() }
                currentPageNumber += 1
                print(currentPageNumber)
                return service.photos(byPageNumber: currentPageNumber, orderBy: orderBy)
            }

         photos = Observable
            .merge(requestFirst, requestNext)
            .map { photos -> [Photo] in
                photos?.forEach { photo in 
                    photoArray.append(photo)
                }
                return photoArray
            }
    }
}


