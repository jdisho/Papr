//
//  HomeViewCellModel.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

struct HomeViewCellModel {

    let userProfileImage: String
    let fullname: String
    let smallPhoto: String
    let regularPhoto: String
    let photoSize: (width: Int, height: Int)

    init(photo: Photo) {
        
        userProfileImage = photo.user?.profileImage?.medium ?? ""
        fullname = photo.user?.fullName ?? ""
        smallPhoto = photo.imageURLs?.small ?? ""
        regularPhoto = photo.imageURLs?.full ?? ""
        photoSize = (width: photo.width ?? 0, height: photo.height ?? 0)
    }
}
