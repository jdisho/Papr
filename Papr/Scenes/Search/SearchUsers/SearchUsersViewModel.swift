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

    // MARK: - Private

    // MARK: - Init

    init() {
        // TODO: Inject dependencies
    }

}
