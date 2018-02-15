//
//  HomeViewCellModel.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeViewCellModel {

    let userProfileImage: Observable<String>
    let fullname: Observable<String>
    let username: Observable<String>
    let smallPhoto: Observable<String>
    let regularPhoto: Observable<String>
    let photoSizeCoef: Observable<Double>
    let created: Observable<String>

    init(photo: Photo) {
        
        let aPhoto = Observable.just(photo)
        
        userProfileImage = aPhoto
            .map { $0.user?.profileImage?.medium ?? "" }
        
        fullname = aPhoto
            .map { $0.user?.fullName ?? "" }

        username = aPhoto
            .map { "@\($0.user?.username ?? "")" }

        smallPhoto = aPhoto
            .map { $0.urls?.small ?? "" }

        regularPhoto = aPhoto
            .map { $0.urls?.regular ?? "" }
        
       photoSizeCoef = aPhoto
            .map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                return Double(height * Int(UIScreen.main.bounds.width) / width)
            }

        created = aPhoto
            .map { $0.created ?? "" }
            .map { $0.toDate }
            .map { date -> String in
                guard let roundedDate = date?.since(Date(), in: .minute).rounded() else { return "" }
                if roundedDate >= 60.0 && roundedDate <= 24 * 60.0 {
                    return "\(Int(date!.since(Date(), in: .hour).rounded()))h"
                } else if roundedDate >= 24 * 60.0 {
                    return "\(Int(date!.since(Date(), in: .day).rounded()))d"
                }
                return "\(Int(roundedDate))m"
            }
    }
}
