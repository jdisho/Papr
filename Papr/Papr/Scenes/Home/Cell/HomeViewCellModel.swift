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
    
    let photo: Photo
    let userPicImageURLString: Observable<String>
    let username: Observable<String>
    let photoURLString: Observable<String>

    init(photo: Photo) {
        self.photo = photo
        
        let asyncPhoto = Observable.just(self.photo)
        userPicImageURLString = asyncPhoto.map { $0.user?.profileImage?.small ?? "" }
        username = asyncPhoto.map { $0.user?.username ?? "" }
        photoURLString = asyncPhoto.map { $0.imageURLs?.regular ?? "" }
    }
}
