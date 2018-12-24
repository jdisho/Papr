//
//  UIView+Rx.swift
//  Papr
//
//  Created by Joan Disho on 24.12.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {

    /// Bindable sink for `backgroundColor` property.
    public var backgroundColor: Binder<UIColor> {
        return Binder(base) { view, color in
            view.backgroundColor = color
        }
    }
}
