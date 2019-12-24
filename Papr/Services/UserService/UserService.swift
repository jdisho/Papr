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

    private let unsplash: TinyNetworking<Unsplash>

    init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>()) {
        self.unsplash = unsplash
    }

    func getMe() -> Observable<Result<User, Papr.Error>> {
        return unsplash.rx
            .request(resource: .getMe)
            .map(to: User.self)
            .map(Result.success)
            .catchError { error in
                let accessToken = UserDefaults.standard.string(forKey: Papr.Unsplash.clientID)
                guard accessToken == nil else {
                    return .just(.failure(.other(message: error.localizedDescription)))
                }
                return .just(.failure(.noAccessToken))
            }
            .asObservable()
    }
}
