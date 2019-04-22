//
//  UIScrollView+Rx.swift
//  Papr
//
//  Created by Joan Disho on 22.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {

    enum Direction {
        case vertical
        case horizontal
    }

    func reachedBottom(withOffset offset: CGFloat = 0.0, direction: Direction = .vertical) -> Observable<Bool> {
        let observable = contentOffset
            .map { [weak base] contentOffset -> Bool in
                guard let scrollView = base else { return false}
                switch direction {
                case .vertical:
                    let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                    let y = contentOffset.y + scrollView.contentInset.top
                    let threshold = max(offset, scrollView.contentSize.height - visibleHeight)

                    return y > threshold
                case .horizontal:
                    let visibleWidth = scrollView.frame.width - scrollView.contentInset.left - scrollView.contentInset.right
                    let w = contentOffset.x + scrollView.contentInset.left
                    let threshold = max(offset, scrollView.contentSize.width - visibleWidth)

                    return w > threshold
                }

        }

        return observable.distinctUntilChanged()
    }
}
