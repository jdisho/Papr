//
//  UIBarButtonItem+Rx.swift
//  Papr
//
//  Created by Joan Disho on 23.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIBarButtonItem {
    
    /// Bindable sink for `image` property.
    public var image: Binder<UIImage> {
        return Binder(base) { button, image in
            button.image = image
        }
    }
}

