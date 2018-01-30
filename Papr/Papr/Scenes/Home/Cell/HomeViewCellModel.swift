//
//  HomeViewCellModel.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

struct HomeViewCellModel {

    let userPicImageURLString: Observable<String>
    let fullname: Observable<String>
    let photoURLString: Observable<String>
    let photoSize: Observable<(Int, Int)>

    init(photo: Photo) {

        let asyncPhoto = Observable.just(photo)
        userPicImageURLString = asyncPhoto.map { $0.user?.profileImage?.medium ?? "" }
        fullname = asyncPhoto.map { $0.user?.fullName ?? "" }
        photoURLString = asyncPhoto.map { $0.imageURLs?.regular ?? "" }
        photoSize = asyncPhoto.map { ($0.width ?? 0, $0.height ?? 0)}
    }
}
