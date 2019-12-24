//
//  UserServiceType.swift
//  Papr
//
//  Created by Joan Disho on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol UserServiceType {
    func getMe() -> Observable<Result<User, Papr.Error>>
}
