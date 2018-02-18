//
//  HomeViewCellModel.swift
//  Papr
//
//  Created by Joan Disho on 07.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol HomeViewCellModelInput {}

protocol HomeViewCellModelOutput {
    var userProfileImage: Observable<String> { get }
    var fullname: Observable<String> { get }
    var username: Observable<String> { get }
    var smallPhoto: Observable<String> { get }
    var regularPhoto: Observable<String> { get }
    var photoSizeCoef: Observable<Double> { get }
    var created: Observable<String> { get }
}

protocol HomeViewCellModelType {
    var inputs: HomeViewCellModelInput { get }
    var outputs: HomeViewCellModelOutput { get }
}

class HomeViewCellModel: HomeViewCellModelType, HomeViewCellModelInput, HomeViewCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: HomeViewCellModelInput { return self }
    var outputs: HomeViewCellModelOutput { return self }
    
    // MARK: Input
    
    // MARK: Output
    let userProfileImage: Observable<String>
    let fullname: Observable<String>
    let username: Observable<String>
    let smallPhoto: Observable<String>
    let regularPhoto: Observable<String>
    let photoSizeCoef: Observable<Double>
    let created: Observable<String>
    
    // MARK: Private
    private let service: PhotoServiceType
    private let photo: Photo
    
    // MARK: Init
    init(photo: Photo,
        service: PhotoServiceType = PhotoService()) {
        
        self.photo = photo
        self.service = service
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
