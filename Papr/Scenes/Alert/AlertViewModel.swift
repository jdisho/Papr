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

protocol AlertViewModelInput {
    var closeAction: CocoaAction { get }
    var yesAction: CocoaAction { get }
    var noAction: CocoaAction { get }
}

protocol AlertViewModelOutput {
    var title: Observable<String> { get }
    var message: Observable<String> { get }
    var mode: Observable<AlertMode> { get }
    
    var yesObservable: Observable<Void> { get }
    var noObservable: Observable<Void> { get }
    var okObservable: Observable<Void> { get }
}

protocol AlertViewModelType {
    var inputs: AlertViewModelInput { get }
    var outputs: AlertViewModelOutput { get }
}

final class AlertViewModel: AlertViewModelType, AlertViewModelInput, AlertViewModelOutput {
    
    // MARK: Inputs & Outputs
    var inputs: AlertViewModelInput { return self }
    var outputs: AlertViewModelOutput { return self }
    
    // MARK: Inputs
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
    
    // MARK: Outputs
    let title: Observable<String>
    let message: Observable<String>
    let mode: Observable<AlertMode>
    let yesObservable: Observable<Void>
    let noObservable: Observable<Void>
    let okObservable: Observable<Void>

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

