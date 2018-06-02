//
//  UserCellModel.swift
//  Papr
//
//  Created by Joan Disho on 02.06.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol UserCellModelInput {}
protocol UserCellModelOutput {
    var fullName: Observable<String> { get }
    var followersNumber: Observable<String> { get }
    var profilePhotoURL: Observable<String> { get }
    var isFollowedByUser: Observable<Bool> { get }
}

protocol UserCellModelType {
    var inputs: UserCellModelInput { get }
    var outputs: UserCellModelOutput { get }
}

class UserCellModel: UserCellModelType, UserCellModelInput, UserCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: UserCellModelInput { return self }
    var outputs: UserCellModelOutput { return self }

    // MARK: Outputs
    let fullName: Observable<String>
    let followersNumber: Observable<String>
    let profilePhotoURL: Observable<String>
    let isFollowedByUser: Observable<Bool>

    // MARK: Init
    init(user: User) {
       let userStream = Observable.just(user)

        fullName = userStream
            .map { $0.fullName }
            .unwrap()

        followersNumber = userStream
            .map { $0.followersCount?.abbreviated }
            .unwrap()

        profilePhotoURL = userStream
            .map { $0.profileImage?.medium }
            .unwrap()

        isFollowedByUser = userStream
            .map { $0.followedByUser }
            .unwrap()
    }
}


