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

class SearchUsersViewModel: AutoModel {

    // MARK: - Inputs
    /// sourcery:begin: input
    let loadMore = BehaviorSubject<Bool>(value: false)
    /// sourcery:end

    // MARK: - Outputs
    /// sourcery:begin: output
    let searchQuery: Observable<String>
    let totalResults: Observable<Int>
    let navTitle: Observable<String>

    lazy var usersViewModel: Observable<[UserCellModelType]> = {
        return Observable.combineLatest(users, searchQuery)
            .map { users, searchQuery in
                users.map { UserCellModel.init(user: $0, searchQuery: searchQuery) }
            }
    }()
    /// sourcery:end

    // MARK: - Private
    private var users: Observable<[User]>!
    private let service: SearchServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: - Init

    init(searchQuery: String,
         service: SearchServiceType = SearchService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
        self.searchQuery = Observable.just(searchQuery)

        var usersArray = [User]([])

        let firstUserSearchResult = service.searchUsers(with: searchQuery, pageNumber: 1)

        totalResults = firstUserSearchResult
            .map { $0.total }
            .unwrap()

        navTitle =  Observable.zip(self.searchQuery, totalResults)
            .map { query, resultsNumber in
                return "\(query): \(resultsNumber) results"
        }

        let requestFirst = firstUserSearchResult
            .map { $0.results }
            .unwrap()

        let requestNext = loadMore
            .count()
            .flatMap { loadMore, count -> Observable<[User]> in
                guard loadMore else { return .empty() }
                return self.service.searchUsers(with: searchQuery, pageNumber: count)
                    .map { $0.results }
                    .unwrap()
            }

        users = Observable.merge(requestFirst, requestNext)
            .map { users -> [User] in
                users.forEach { user in
                    usersArray.append(user)
                }
                return usersArray
            }
    }
}
