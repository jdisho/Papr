//  
//  SearchCollectionsViewModel.swift
//  Papr
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchCollectionsViewModelInput {
}

protocol SearchCollectionsViewModelOutput {
}

protocol SearchCollectionsViewModelType {
    var input: SearchCollectionsViewModelInput { get }
    var output: SearchCollectionsViewModelOutput { get }
}

final class SearchCollectionsViewModel: SearchCollectionsViewModelType, SearchCollectionsViewModelInput, SearchCollectionsViewModelOutput {

    var input: SearchCollectionsViewModelInput { return self }
    var output: SearchCollectionsViewModelOutput { return self }

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Private

    // MARK: - Init

    init() {
        // TODO: Inject dependencies
    }

}
