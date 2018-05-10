//  
//  SearchViewController.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: SearchViewModelType!

    // MARK: IBOutlets

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: BindableType

    func bindViewModel() {
       viewModel.outputs.searchResults.debug().subscribe()
    }
  
}
