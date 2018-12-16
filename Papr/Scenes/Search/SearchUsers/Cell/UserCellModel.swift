//
//  UserCellModel.swift
//  Papr
//
//  Created by Joan Disho on 02.06.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

class UserCellModel: AutoModel {

    // MARK: Outputs
    /// sourcery:begin: output
    let fullName: Observable<NSAttributedString>
    let profilePhotoURL: Observable<String>
    /// sourcery:end

    // MARK: Init
    init(user: User, searchQuery: String) {
       let userStream = Observable.just(user)

        fullName = userStream
            .map { $0.fullName?.attributedString(withHighlightedText: searchQuery) }
            .unwrap()

        profilePhotoURL = userStream
            .map { $0.profileImage?.medium }
            .unwrap()
    }
}


