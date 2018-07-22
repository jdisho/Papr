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
    var reachedBottom: ControlEvent<Bool> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Bool> in
                guard let scrollView = base else { return .empty() }
                let visibleHeight = scrollView.frame.height
                    - scrollView.contentInset.top
                    - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return .just(y > threshold)
        }

        return ControlEvent(events: observable)
    }
}
