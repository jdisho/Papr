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
    func reachedBottom(withOffset offset: CGFloat = 0.0) -> Observable<Bool> {
        let observable = contentOffset
            .map { [weak base] contentOffset -> Bool in
                guard let scrollView = base else { return false}
                let visibleHeight = scrollView.frame.height
                    - scrollView.contentInset.top
                    - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(offset, scrollView.contentSize.height - visibleHeight)

                return y > threshold
        }

        return observable.distinctUntilChanged()
    }
}
