//
//  ObservableType+Extras.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func toVoidObservable() -> Observable<Void> {
        return self.map { _ in }
    }
    
    func unwrap<T>() -> Observable<T> where E == Optional<T> {
        return self.filter { $0 != nil }.map { $0! }
    }
    
}

extension Observable where E == Bool {
    
    var negation: Observable<Bool> {
        return self.map { !$0 }
    }

}
