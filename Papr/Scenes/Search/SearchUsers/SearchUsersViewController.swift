//  
//  SearchUsersViewController.swift
//  Papr
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchUsersViewController: UIViewController, BindableType {

    var viewModel: SearchUsersViewModel!

    // MARK: Private
    private let disposeBag = DisposeBag()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - BindableType

    func bindViewModel() {
        let inputs = viewModel.input
        let outputs = viewModel.output

        Observable.zip(outputs.searchQuery, outputs.totalResults)
            .map { query, resultsNumber in
                return "\(query): \(resultsNumber) results"
            }
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
    }
  
}
