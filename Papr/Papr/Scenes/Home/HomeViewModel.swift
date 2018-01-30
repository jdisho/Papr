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

class HomeViewModel {

    var input: Input!

    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()

    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, 
         service: PhotoServiceType = PhotoService(), 
         input: Input = Input()) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service
        self.input = input
    }

    func createHomeViewCellModel(for photo: Photo) -> HomeViewCellModel {
        return HomeViewCellModel(photo: photo)
    }
}

extension HomeViewModel: ViewModelType {

    struct Input {
        let loadMore = BehaviorSubject<Bool>(value: false)
        let orderBy = BehaviorSubject<OrderBy>(value: .latest)
    }

    struct Output {
        var asyncPhotos: Observable<[Photo]>!
    }

    func transform(input: Input) -> Output {
        
        var currentPageNumber = 0
        var photoArray = [Photo]([])
        
        let photosFromService = Observable
            .combineLatest(input.loadMore, input.orderBy)
            .flatMap { loadMore, orderBy -> Observable<[Photo]?> in 
                if loadMore {
                    currentPageNumber += 1
                    return self.service.photos(by: currentPageNumber, orderBy: orderBy)
                }
                return .empty()
            }
        
        let asyncPhotos = photosFromService
            .map { photos -> [Photo] in
                photos?.forEach { photo in 
                    photoArray.append(photo)
                }
            return photoArray
            }

        return Output(asyncPhotos: asyncPhotos)
    }

}
