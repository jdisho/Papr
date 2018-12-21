//
//  SearchResultCell.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultCell: UITableViewCell, BindableType, ClassIdentifiable {

    // MARK: ViewModel
    var viewModel: SearchResultCellModelType!

    // MARK: Private
    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    // MARK: BindableType
    func bindViewModel() {
        viewModel.outputs.searchResult
            .map { $0.description }
            .bind(to: textLabel!.rx.text)
            .disposed(by: disposeBag)
    }
}
