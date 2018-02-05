//
//  HomeViewController.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import NSObject_Rx

class HomeViewController: UIViewController, BindableType {
    
    // MARK: ViewModel

    var viewModel: HomeViewModel!

    // MARK: IBOutlets

    @IBOutlet var tableView: UITableView!
    
    // MARK: Private

    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Photo>>!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationController()
        configureTableView()
    }

    // MARK: UI
    
    private func configureNavigationController() {
        self.title = "Home 🏡"
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = 300
        tableView.registerCell(type: HomeViewCell.self)
    }

    // MARK: BindableType

    func bindViewModel() {
        guard let input = viewModel.input else { return }
        let output = viewModel.transform(input: input)

        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Photo>>(
            configureCell: { [unowned self] (dataSource, tableView, indexPath, item) in 
            var cell = tableView.dequeueResuableCell(type: HomeViewCell.self, forIndexPath: indexPath)
            cell.bind(to: self.viewModel.createHomeViewCellModel(for: item))
            return cell
        })

        output.asyncPhotos
            .map { [SectionModel(model: "", items: Array($0))] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        self.tableView.rx
            .contentOffset
            .flatMap { [unowned self] _ in 
                Observable
                    .just(self.tableView.isNearTheBottomEdge())
            }
            .distinctUntilChanged()
            .bind(to: input.loadMore)
            .disposed(by: rx.disposeBag)
    }
}

extension UIScrollView {

    func isNearTheBottomEdge(offset: CGFloat = 100) -> Bool {
        return self.contentOffset.y + self.frame.size.height + offset >= self.contentSize.height
    }

}
