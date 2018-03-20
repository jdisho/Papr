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

    private var unsplash: Unsplash

    init(unsplash: Unsplash = Unsplash()) {
        self.unsplash = unsplash
    }

    func getMe() -> Observable<User> {
        let resource = SimpleResource<User>(url: UnsplashAPI.getMe.path)
        return unsplash.request(resource).asObservable()
    }
}
