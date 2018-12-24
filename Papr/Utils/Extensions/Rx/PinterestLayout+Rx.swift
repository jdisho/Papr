//
//  PinterestLayout+Rx.swift
//  Papr
//
//  Created by Joan Disho on 05.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: PinterestLayout {

    private var delegate: RxPinterestLayoutDelegateProxy {
        return RxPinterestLayoutDelegateProxy.proxy(for: base)
    }

    func updateSize(_ indexPath: IndexPath) -> Binder<CGSize> {
        return Binder(base) { base, size in
            self.delegate.sizes[indexPath] = size
            base.invalidateLayout()
        }
    }
}
