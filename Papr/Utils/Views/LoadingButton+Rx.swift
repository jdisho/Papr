//
//  LoadingButton+Rx.swift
//  Papr
//
//  Created by Piotr on 19/10/2019.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: LoadingButton {
    var isLoading: Binder<Bool> {
        return Binder(base) { view, isLoading in
            view.isLoading = isLoading
        }
    }
}
