//
//  CollectionsViewModel.swift
//  Papr
//
//  Created by Joan Disho on 04.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol CollectionsViewModelInput {}
protocol CollectionsViewModelOutput {
    var collectionCellsModelType: Observable<[CollectionCellViewModelType]> { get }
}
protocol CollectionsViewModelType {
    var input: CollectionsViewModelInput { get }
    var output: CollectionsViewModelOutput { get }
}

class CollectionsViewModel: CollectionsViewModelType,
                            CollectionsViewModelInput,
                            CollectionsViewModelOutput {
    // MARK: Inputs & Outputs
    var input: CollectionsViewModelInput { return self }
    var output: CollectionsViewModelOutput { return self }

    // MARK: Inputs

    // MARK: Outputs
    lazy var collectionCellsModelType: Observable<[CollectionCellViewModelType]> = {
        return photoCollections.mapMany { CollectionCellViewModel(photoCollection: $0) }
    }()

    // MARK: Private
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let photoCollections: Observable<[PhotoCollection]>

    // MARK: Init
    init(service: CollectionServiceType = CollectionService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator

        photoCollections = service
            .collections(byPageNumber: 1, curated: false)
            .flatMap { result -> Observable<[PhotoCollection]> in
                switch result {
                case let .success(photoCollections):
                    return Observable.just(photoCollections)
                case .error(_):
                    return Observable.empty()
                }
            }
    }
}
