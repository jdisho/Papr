//
//  AlertViewModel.swift
//  Papr
//
//  Created by Joan Disho on 25.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

enum AlertMode {
    case ok
    case yesNo
}

class AlertViewModel: AutoModel {
  
    // MARK: Inputs
    /// sourcery:begin: input
    lazy var closeAction: CocoaAction = {
        CocoaAction { [unowned self] in
            self.okPublisher.onNext(())
            return .empty()
        }
    }()
    
    lazy var yesAction: CocoaAction = {
        CocoaAction { [unowned self] in
            self.okPublisher.onNext(())
            return .empty()
        }
    }()
    
    lazy var noAction: CocoaAction = {
        CocoaAction { [unowned self] in
            self.noPublisher.onNext(())
            return .empty()
        }
    }()
    /// sourcery:end
    
    // MARK: Outputs
    /// sourcery:begin: output
    let title: Observable<String>
    let message: Observable<String>
    let mode: Observable<AlertMode>
    let yesObservable: Observable<Void>
    let noObservable: Observable<Void>
    let okObservable: Observable<Void>
    /// sourcery:end

    // MARK: Private
    private let yesPublisher = PublishSubject<Void>()
    private let noPublisher = PublishSubject<Void>()
    private let okPublisher = PublishSubject<Void>()

    // MARK: Init
    init(title: String, message: String, mode: AlertMode) {
        
        self.title = Observable.just(title)
        self.message = Observable.just(message)
        self.mode = Observable.just(mode)
        
        yesObservable = yesPublisher.asObservable()
        noObservable = noPublisher.asObservable()
        okObservable = okPublisher.asObservable()
    }
}

