//
//  UserProfileViewModel.swift
//  Papr
//
//  Created by Joan Disho on 09.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol UserProfileViewModelInput {
    var logoutAction: CocoaAction { get }
}

protocol UserProfileViewModelOutput {
}

protocol UserProfileViewModelType {
    var inputs: UserProfileViewModelInput { get }
    var outputs: UserProfileViewModelOutput { get }
}

class UserProfileViewModel: UserProfileViewModelType, UserProfileViewModelInput, UserProfileViewModelOutput {
    
    var inputs: UserProfileViewModelInput { return self }
    var outputs: UserProfileViewModelOutput { return self }
    
    
    // MARK: Private
    private let sceneCoordinator: SceneCoordinatorType
    
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
    }
    
    
    lazy var logoutAction: CocoaAction = {
        return CocoaAction { _ in
            UnsplashAuthManager.shared.clearAccessToken()
            
            return self.sceneCoordinator.transition(to: Scene.papr)
        }
    }()
}
