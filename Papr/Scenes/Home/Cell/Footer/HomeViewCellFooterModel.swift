//
//  HomeViewCellFooterModel.swift
//  Papr
//
//  Created by Joan Disho on 28.04.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewCellFooterModelInput {}
protocol HomeViewCellFooterModelOutput {}

protocol HomeViewCellFooterModelType {
    var inputs: HomeViewCellFooterModelInput { get }
    var outputs: HomeViewCellFooterModelOutput { get }
}

struct HomeViewFooterModel: HomeViewCellFooterModelInput,
                            HomeViewCellFooterModelOutput,
                            HomeViewCellFooterModelType  {

    var inputs: HomeViewCellFooterModelInput { return self }
    var outputs: HomeViewCellFooterModelOutput { return self }

    init() {}
}
