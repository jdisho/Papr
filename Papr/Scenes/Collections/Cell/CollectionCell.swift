//
//  CollectionCell.swift
//  Papr
//
//  Created by Joan Disho on 05.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell, BindableType {

    var viewModel: CollectionCellViewModelType!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindViewModel() {
        let output = viewModel.output
    }
}
