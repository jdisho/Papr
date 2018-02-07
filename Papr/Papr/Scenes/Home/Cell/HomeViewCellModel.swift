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

    let userProfileImage = BehaviorRelay<String>(value: "")
    let fullname = BehaviorRelay<String>(value: "")
    let smallPhoto = BehaviorRelay<String>(value: "")
    let regularPhoto = BehaviorRelay<String>(value: "")
    let photoSizeCoef = BehaviorRelay<Double>(value: 0.0)
    let created = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()

    init(photo: Photo) {

        let asyncPhoto = Observable.just(photo)
        
        asyncPhoto.map { $0.user?.profileImage?.medium ?? "" }
            .bind(to: userProfileImage)
            .disposed(by: disposeBag)
        
        asyncPhoto.map {$0.user?.fullName ?? ""}
            .bind(to: fullname)
            .disposed(by: disposeBag)
        
        asyncPhoto.map {$0.imageURLs?.small ?? ""}
            .bind(to: smallPhoto)
            .disposed(by: disposeBag)
        
        asyncPhoto.map {$0.imageURLs?.full ?? ""}
            .bind(to: regularPhoto)
            .disposed(by: disposeBag)
    
        asyncPhoto.map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                return Double(height * Int(UIScreen.main.bounds.width) / width)
            }
            .bind(to: photoSizeCoef)
            .disposed(by: disposeBag)

        asyncPhoto.map { $0.created ?? "" }
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
            .bind(to: created)
            .disposed(by: disposeBag)
    }
}
