//
//  UserService.swift
//  Papr
//
//  Created by Joan Disho on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import TinyNetworking
import RxSwift

struct UserService: UserServiceType {

    private var unsplash: TinyNetworking<Unsplash>

    init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>()) {
        self.unsplash = unsplash
    }

    func getMe() -> Observable<User> {
        return unsplash.rx
            .request(resource: .getMe)
            .map(to: User.self)
            .asObservable()
    }
}
