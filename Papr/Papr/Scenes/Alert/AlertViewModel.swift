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
    case cancel
    case yesOrNo
}
class AlertViewModel {

    let title = Variable("")
    let message = Variable("")
    let mode = Variable<AlertMode>(.cancel)
    
    let yesPublisher = PublishSubject<Void>()
    let noPublisher = PublishSubject<Void>()
    let cancelPublisher = PublishSubject<Void>()
    
    private let sceneCoordinator: SceneCoordinatorType
    
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
    }
    
    // MARK: Actions
    
    lazy var cancelAction: CocoaAction = {
        return CocoaAction {
            self.cancelPublisher.onNext(())
            return .empty()
        }
    }()
    
    lazy var yesAction: CocoaAction = {
        return CocoaAction {
            self.yesPublisher.onNext(())
            return .empty()
        }
    }()
    
    lazy var noAction: CocoaAction = {
        return CocoaAction {
            self.noPublisher.onNext(())
            return .empty()
        }
    }()

}
