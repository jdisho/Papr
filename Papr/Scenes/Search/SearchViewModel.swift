//  
//  SearchViewModel.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchViewModelInput {
    var searchString: BehaviorSubject<String> { get }
}

protocol SearchViewModelOutput {
    var searchResults: Observable<[String]> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInput { get }
    var outputs: SearchViewModelOutput { get }
}

class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput {

    var inputs: SearchViewModelInput { return self }
    var outputs: SearchViewModelOutput { return self }

    // MARK: - Inputs
    var searchString = BehaviorSubject<String>(value: "")

    // MARK: - Outputs
    let searchResults: Observable<[String]>

    // MARK: - Private
    private let service: SearchServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: - Init

    init(service: SearchServiceType = SearchService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator

        let predefinedText = Observable.of(["Photos with ", "Collections with", "Users with"])

        searchResults = Observable.combineLatest(predefinedText, searchString)
            .map { predefinedText, query -> [String] in
                return predefinedText.map { $0 + "\"\(query)\"" }
            }

    }


}
