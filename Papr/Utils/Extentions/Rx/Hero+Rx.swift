//
//  Hero+Rx.swift
//  Papr
//
//  Created by Joan Disho on 15.04.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Hero

extension Reactive where Base: UIView {

    /// Bindable sink for `hero.id`.
    public var heroId: Binder<String> {
        return Binder(base) { view, id in
            view.hero.id = id
        }
    }

}

