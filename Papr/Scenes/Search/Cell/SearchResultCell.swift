//
//  SearchResultCell.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultCell: UITableViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: SearchResultCellModelType!

    // MARK: IBOutlets
    @IBOutlet var titleLabel: UILabel!

    // MARK: Private
    private let disposeBag = DisposeBag()

    // MARK: BindableType
    func bindViewModel() {
        viewModel.outputs.searchResult
            .map { $0.description }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
