//
//  SearchResultCellModel.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

    // MARK: SearchResult

struct SearchResult: Equatable {
    let query: String
    let description: String

    init(query: String, predefinedText: String) {
        self.query = query
        description = predefinedText + " \"\(query)\""
    }
}

extension SearchResult: IdentifiableType {
    var identity: String {
        return query
    }
}

    // MARK: SearchResultCellModel

protocol SearchResultCellModelInput {}

protocol SearchResultCellModelOutput {
    var searchResult: Observable<SearchResult> { get }
}

protocol SearchResultCellModelType {
    var inputs: SearchResultCellModelInput { get }
    var outputs: SearchResultCellModelOutput { get }
}

final class SearchResultCellModel: SearchResultCellModelType,
                            SearchResultCellModelInput,
                            SearchResultCellModelOutput {
    // MARK: Inputs & Outputs
    var inputs: SearchResultCellModelInput { return self }
    var outputs: SearchResultCellModelOutput { return self }

    // MARK: Outputs
    let searchResult: Observable<SearchResult>

    init(searchResult: SearchResult) {
        self.searchResult = Observable.just(searchResult)
    }
}
