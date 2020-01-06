//
//  UIRefreshControl+Rx.swift
//  Papr
//
//  Created by Joan Disho on 05.01.20.
//  Copyright © 2020 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIRefreshControl {
    func isRefreshing(in collectionView: UICollectionView) -> Binder<Bool> {
        return Binder(self.base) { refreshControl, refresh in
            if refresh {
                refreshControl.beginRefreshing()
                collectionView.setContentOffset(
                    CGPoint(x: 0, y: -refreshControl.frame.size.height),
                    animated: true
                )
            } else {
                refreshControl.endRefreshing()
                collectionView.setContentOffset(.zero, animated: true)
            }
        }
    }
}
