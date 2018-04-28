//
//  UserServiceType.swift
//  Papr
//
//  Created by Joan Disho on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

//enum Result<T, E> {
//    case success(T)
//    case error(E)
//}
//
//enum NonPublicScopeError {
//    case noAccessToken
//    case error(withMessage: String)
//}


protocol UserServiceType {
    func getMe() -> Observable<Result<User, NonPublicScopeError>>
}
