//
//  CreateCollectionViewModel.swift
//  Papr
//
//  Created by Joan Disho on 29.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol CreateCollectionViewModelInput {

}

protocol CreateCollectionViewModelOutput {

}

protocol CreateCollectionViewModelType {
    var inputs: CreateCollectionViewModelInput { get }
    var outputs: CreateCollectionViewModelOutput {  get}
}

class CreateCollectionViewModel: CreateCollectionViewModelInput,
                                CreateCollectionViewModelOutput,
                                CreateCollectionViewModelType  {

    // MARK: Inputs & Outputs
    var inputs: CreateCollectionViewModelInput { return self }
    var outputs: CreateCollectionViewModelOutput { return self }
    
}
