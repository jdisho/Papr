//
//  UIAlertController+Rx.swift
//  Papr
//
//  Created by Joan Disho on 25.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIAlertController {
    
    /// Bindable sink for `title`.
    public var title: Binder<String> {
        return Binder(base) { alertController, title in
            alertController.title = title
        }
    }
    
    /// Bindable sink for `message`.
    public var message: Binder<String> {
        return Binder(base) { alertController, message in
            alertController.message = message
        }
    }
}
