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
    var searchString: BehaviorSubject<String?> { get }
    var searchTrigger: AnyObserver<Int>! { get }
}

protocol SearchViewModelOutput {
    var searchResultCellModel: Observable<[SearchResultCellModelType]> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInput { get }
    var outputs: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput {

    var inputs: SearchViewModelInput { return self }
    var outputs: SearchViewModelOutput { return self }

    // MARK: - Inputs
    var searchString = BehaviorSubject<String?>(value: nil)
    var searchTrigger: AnyObserver<Int>!

    // MARK: - Outputs
    lazy var searchResultCellModel: Observable<[SearchResultCellModelType]> = {
        return searchResults.mapMany { SearchResultCellModel(searchResult: $0) }
    }()

    // MARK: - Private
    private let sceneCoordinator: SceneCoordinatorType
    private let searchResults: Observable<[SearchResult]>

    private lazy var searchAction: Action<Int, Void> = {
        return Action<Int, Void> { [weak self] row in
            guard let `self` = self,
                let query = try? self.searchString.value() else { return .empty() }
            switch row {
            case 0:
                let viewModel = SearchPhotosViewModel(type: .searchPhotos(searchQuery: query, searchService: SearchService()))
                return self.sceneCoordinator.transition(to: Scene.searchPhotos(viewModel))
            case 1:
                let viewModel = SearchCollectionsViewModel()
                return self.sceneCoordinator.transition(to: Scene.searchCollections(viewModel))
            case 2:
                let viewModel = SearchUsersViewModel(searchQuery: query)
                return self.sceneCoordinator.transition(to: Scene.searchUsers(viewModel))
            default: return .empty()
            }
        }
    }()

    // MARK: - Init

    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator

        let predefinedText = Observable.of(["Photos with ", "Collections with", "Users with"])

        searchResults = Observable.combineLatest(predefinedText, searchString.unwrap())
            .map { predefinedText, query -> [SearchResult] in
                return predefinedText.map { SearchResult(query: query, predefinedText: $0) }
            }

        searchTrigger = searchAction.inputs
    }
}
