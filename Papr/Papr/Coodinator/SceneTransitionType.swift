//
//  SceneTransitionType.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

enum SceneTransitionType {
    // you can extend this to add animated transition types,
    // interactive transitions and even child view controllers!
    
    case root       // make view controller the root view controller
    case push       // push view controller to navigation stack
    case modal      // present view controller modally
    case alert      // present alert
}



