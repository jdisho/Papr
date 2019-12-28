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
    var fullName: Observable<NSAttributedString> { get }
    var profilePhotoURL: Observable<URL> { get }
}

protocol UserCellModelType {
    var inputs: UserCellModelInput { get }
    var outputs: UserCellModelOutput { get }
}

final class UserCellModel: UserCellModelType, UserCellModelInput, UserCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: UserCellModelInput { return self }
    var outputs: UserCellModelOutput { return self }

    // MARK: Outputs
    let fullName: Observable<NSAttributedString>
    let profilePhotoURL: Observable<URL>

    // MARK: Init
    init(user: User, searchQuery: String) {
       let userStream = Observable.just(user)

        fullName = userStream
            .map { $0.fullName?.attributedString(withHighlightedText: searchQuery) }
            .unwrap()

        profilePhotoURL = userStream
            .map { $0.profileImage?.medium }
            .unwrap()
            .mapToURL()
    }
}


