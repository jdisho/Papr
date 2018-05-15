//  
//  SearchUsersViewModel.swift
//  Papr
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchUsersViewModelInput {
}

protocol SearchUsersViewModelOutput {
    var searchQuery: Observable<String> { get }
    var totalResults: Observable<Int> { get }
}

protocol SearchUsersViewModelType {
    var input: SearchUsersViewModelInput { get }
    var output: SearchUsersViewModelOutput { get }
}

class SearchUsersViewModel: SearchUsersViewModelType, SearchUsersViewModelInput, SearchUsersViewModelOutput {

    var input: SearchUsersViewModelInput { return self }
    var output: SearchUsersViewModelOutput { return self }

    // MARK: - Inputs

    // MARK: - Outputs
    var searchQuery: Observable<String>
    var totalResults: Observable<Int>

    // MARK: - Private
    private let service: SearchServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: - Init

    init(searchQuery: String,
         service: SearchServiceType = SearchService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
        self.searchQuery = Observable.just(searchQuery)

        let users = service.searchUsers(with: searchQuery, pageNumber: 10)

        totalResults = users.map { $0.total }.unwrap()
        
    }

}
