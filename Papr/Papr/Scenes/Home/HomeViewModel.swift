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
    var loadMore: BehaviorSubject<Bool> { get }
    var orderBy: BehaviorSubject<OrderBy> { get }
}

protocol HomeViewModelOutput {
    var asyncPhotos: Observable<[Photo]>! { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
    func createHomeViewCellModel(for photo: Photo) -> HomeViewCellModel
}

class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput{

    // MARK: Input & Output
    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }

    // MARK: Input
    let loadMore = BehaviorSubject<Bool>(value: false)
    let orderBy = BehaviorSubject<OrderBy>(value: .latest)
    
    // MARK: Output
    var asyncPhotos: Observable<[Photo]>!
    
    // MARK: Private
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, 
         service: PhotoServiceType = PhotoService()) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service

        var currentPageNumber = 0
        var photoArray = [Photo]([])
        
        let photosFromService = Observable
            .combineLatest(loadMore, orderBy)
            .flatMap { loadMore, orderBy -> Observable<[Photo]?> in 
                if loadMore {
                    currentPageNumber += 1
                    print("loadMore")
                    return self.service.photos(byPageNumber: currentPageNumber, orderBy: orderBy)
                }
                return .empty()
            }

        asyncPhotos = photosFromService
            .map { photos -> [Photo] in
                photos?.forEach { photo in 
                    photoArray.append(photo)
                }
            return photoArray
            }
    }

    // MARK: HomeViewCellModel
    func createHomeViewCellModel(for photo: Photo) -> HomeViewCellModel {
        return HomeViewCellModel(photo: photo)
    }
}


