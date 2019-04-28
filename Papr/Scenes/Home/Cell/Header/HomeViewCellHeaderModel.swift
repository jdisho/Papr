//
//  HomeViewCellHeaderModel.swift
//  Papr
//
//  Created by Joan Disho on 27.04.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewCellHeaderModelInput {}
protocol HomeViewCellHeaderModelOutput {
    var profileImageURL: Observable<URL> { get }
    var fullName: Observable<String> { get }
    var userName: Observable<String> { get }
    var updatedTime: Observable<String> { get }
}

protocol HomeViewCellHeaderModelType {
    var inputs: HomeViewCellHeaderModelInput { get }
    var outputs: HomeViewCellHeaderModelOutput { get }
}

struct HomeViewCellHeaderModel: HomeViewCellHeaderModelInput,
                                HomeViewCellHeaderModelOutput,
                                HomeViewCellHeaderModelType {

    var inputs: HomeViewCellHeaderModelInput { return self }
    var outputs: HomeViewCellHeaderModelOutput { return self }

    // MARK: Outputs
    let profileImageURL: Observable<URL>
    let fullName: Observable<String>
    let userName: Observable<String>
    let updatedTime: Observable<String>

    init(photo: Photo) {
        let photoStream = Observable.just(photo)

        profileImageURL = photoStream
            .map {  $0.user?.profileImage?.large }
            .unwrap()
            .mapToURL()

        fullName = photoStream
            .map { $0.user?.fullName }
            .unwrap()

        userName = photoStream
            .map { "@\($0.user?.username ?? "")" }
            .unwrap()

        updatedTime = photoStream
            .map { $0.updated?.toDate?.abbreviated }
            .unwrap()
    }
}
