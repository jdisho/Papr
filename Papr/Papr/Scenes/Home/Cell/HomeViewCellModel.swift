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
import RxCocoa

protocol HomeViewCellModelInput {
    var likePhotoAction: CocoaAction { get }
    var unlikePhotoAction: CocoaAction { get }
    func update(photo: Photo) -> Observable<Void>
}

protocol HomeViewCellModelOutput {
    var userProfileImage: Observable<String> { get }
    var fullname: Observable<String> { get }
    var username: Observable<String> { get }
    var smallPhoto: Observable<String> { get }
    var regularPhoto: Observable<String> { get }
    var photoSizeCoef: Observable<Double> { get }
    var created: Observable<String> { get }
    var likesNumber: Observable<String> { get }
    var likedByUser:  Observable<Bool> { get }
}

protocol HomeViewCellModelType {
    var inputs: HomeViewCellModelInput { get }
    var outputs: HomeViewCellModelOutput { get }
}

class HomeViewCellModel: HomeViewCellModelType, 
                         HomeViewCellModelInput, 
                         HomeViewCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: HomeViewCellModelInput { return self }
    var outputs: HomeViewCellModelOutput { return self }
    
    // MARK: Input
    lazy var likePhotoAction: CocoaAction = { 
        return CocoaAction { [unowned self] in
            self.service
                .like(photoWithId: self.photo.id ?? "")
                .unwrap()
                .flatMap { photo in self.update(photo: photo)}
                .ignoreAll()
        }
    }()

    lazy var unlikePhotoAction: CocoaAction = {
        return CocoaAction { [unowned self] in
            self.service
                .unlike(photoWithId: self.photo.id ?? "")
                .unwrap()
                .flatMap { photo in self.update(photo: photo)}
                .ignoreAll()
        }
    }()

    func update(photo: Photo) -> Observable<Void> {
        initialPhotoLikeNumber.onNext(photo.likes ?? 0)
        isPhotoLiked.onNext(photo.likedByUser ?? false)
        return .empty()
    }

    // MARK: Output
    let userProfileImage: Observable<String>
    let fullname: Observable<String>
    let username: Observable<String>
    let smallPhoto: Observable<String>
    let regularPhoto: Observable<String>
    let photoSizeCoef: Observable<Double>
    let created: Observable<String>
    let likesNumber: Observable<String>
    let likedByUser: Observable<Bool>

    // MARK: Private
    private let service: PhotoServiceType
    private let photo: Photo
    private let initialPhotoLikeNumber = BehaviorSubject<Int>(value: 0)
    private let isPhotoLiked = BehaviorSubject<Bool>(value: false)

    // MARK: Init
    init(photo: Photo,
        service: PhotoServiceType = PhotoService()) {

        self.photo = photo
        self.service = service
        let photoStream = Observable.just(photo)

        userProfileImage = photoStream
            .map { $0.user?.profileImage?.medium ?? "" }

        fullname = photoStream
            .map { $0.user?.fullName ?? "" }

        username = photoStream
            .map { "@\($0.user?.username ?? "")" }

        smallPhoto = photoStream
            .map { $0.urls?.small ?? "" }

        regularPhoto = photoStream
            .map { $0.urls?.regular ?? "" }

       photoSizeCoef = photoStream
            .map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                return Double(height * Int(UIScreen.main.bounds.width) / width)
            }

        created = photoStream
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

        initialPhotoLikeNumber.onNext(photo.likes ?? 0)
        likesNumber = initialPhotoLikeNumber
            .map { likes in
                guard likes != 0 else { return "" }
                guard likes != 1 else { return "\(likes) like"}
                return "\(likes) likes"
            }
        
        isPhotoLiked.onNext(photo.likedByUser ?? false)
        likedByUser = isPhotoLiked.asObservable()
    }
}
