//
//  UserService.swift
//  Papr
//
//  Created by Joan Disho on 14.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct UserService: UserServiceType {

    private var unsplash: MoyaProvider<Unsplash>

    init(unsplash: MoyaProvider<Unsplash> = MoyaProvider<Unsplash>()) {
        self.unsplash = unsplash
    }

    func getMe() -> Observable<Result<User, NonPublicScopeError>> {
        return unsplash.rx
            .request(.getMe)
            .map(User.self)
            .map(Result.success)
            .catchError { error in
                let accessToken = UserDefaults.standard.string(forKey: UnsplashSettings.clientID.string)
                guard accessToken == nil else {
                    return .just(.error(.error(withMessage: error.localizedDescription)))
                }
                return .just(.error(.noAccessToken))
            }
            .asObservable()
    }
}
