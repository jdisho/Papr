//
//  CollectionCellViewModel.swift
//  Papr
//
//  Created by Joan Disho on 05.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol CollectionCellViewModelInput {}
protocol CollectionCellViewModelOutput {}
protocol CollectionCellViewModelType {
    var input: CollectionCellViewModelInput { get }
    var output: CollectionCellViewModelOutput { get }
}

class CollectionCellViewModel: CollectionCellViewModelType,
                                CollectionCellViewModelInput,
                                CollectionCellViewModelOutput {

    // MARK: Input & Output
    var input: CollectionCellViewModelInput { return self }
    var output: CollectionCellViewModelOutput { return self }
}
