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

    // MARK: Private
    private let service: CollectionServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: Init
    init(service: CollectionServiceType = CollectionService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
    }
}
