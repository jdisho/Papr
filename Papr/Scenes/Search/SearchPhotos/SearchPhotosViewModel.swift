//  
//  SearchPhotosViewModel.swift
//  Papr
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchPhotosViewModelInput {
}

protocol SearchPhotosViewModelOutput {
}

protocol SearchPhotosViewModelType {
    var input: SearchPhotosViewModelInput { get }
    var output: SearchPhotosViewModelOutput { get }
}

class SearchPhotosViewModel: SearchPhotosViewModelType, SearchPhotosViewModelInput, SearchPhotosViewModelOutput {

    var input: SearchPhotosViewModelInput { return self }
    var output: SearchPhotosViewModelOutput { return self }

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Private

    // MARK: - Init

    init() {
        // TODO: Inject dependencies
    }

}
