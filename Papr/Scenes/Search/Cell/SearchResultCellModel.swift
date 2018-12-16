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


class SearchResultCellModel: AutoModel {
 
    // MARK: Outputs
    /// sourcery:begin: output
    let searchResult: Observable<SearchResult>
    /// sourcery:end

    init(searchResult: SearchResult) {
        self.searchResult = Observable.just(searchResult)
    }
}
