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

protocol HomeViewCellModelInput {
    var likePhotoAction: Action<Void, Photo> { get }
    var unlikePhotoAction: Action<Void, Photo> { get }
    var alertAction: Action<String, Void> { get }
    var photoDetailsAction: CocoaAction { get }
    func update(photo: Photo) -> Photo
}

protocol HomeViewCellModelOutput {
    var userProfileImage: Observable<String> { get }
    var fullname: Observable<String> { get }
    var username: Observable<String> { get }
    var smallPhoto: Observable<String> { get }
    var regularPhoto: Observable<String> { get }
    var photoSizeCoef: Observable<Double> { get }
    var updated: Observable<String> { get }
    var likesNumber: Observable<String> { get }
    var likedByUser:  Observable<Bool> { get }
    var photoDescription: Observable<String> { get }
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
    lazy var likePhotoAction: Action<Void, Photo>  = { 
        return Action<Void, Photo>  { [unowned self] in
            self.service
                .like(photoWithId: self.photo.id ?? "")
                .map { $0.photo }
                .unwrap()
                .map { photo in self.update(photo: photo)}
        }
    }()

    lazy var unlikePhotoAction: Action<Void, Photo>  = {
        return Action<Void, Photo>  { [unowned self] in
            self.service
                .unlike(photoWithId: self.photo.id ?? "")
                .map { $0.photo }
                .unwrap()
                .map { photo in self.update(photo: photo)}
        }
    }()

    lazy var alertAction: Action<String, Void> = {
        return Action<String, Void> { [unowned self] message in
            let alertViewModel = AlertViewModel(title: "Upsss...", 
                                                message: message, 
                                                mode: .ok)
            return self.sceneCoordinator.transition(to: .alert(alertViewModel), 
                                                    type: .alert)
        }
    }()

    lazy var photoDetailsAction: CocoaAction = {
        return CocoaAction { [unowned self] in
            let viewModel = PhotoDetailsViewModel()
            return self.sceneCoordinator.transition(to: .photoDetails(viewModel), type: .modal)
        }
    }()

    func update(photo: Photo) -> Photo {
        initialPhotoLikeNumber.onNext(photo.likes ?? 0)
        isPhotoLiked.onNext(photo.likedByUser ?? false)
        return photo
    }

    // MARK: Output
    let userProfileImage: Observable<String>
    let fullname: Observable<String>
    let username: Observable<String>
    let smallPhoto: Observable<String>
    let regularPhoto: Observable<String>
    let photoSizeCoef: Observable<Double>
    let updated: Observable<String>
    let likesNumber: Observable<String>
    let likedByUser: Observable<Bool>
    let photoDescription: Observable<String>

    // MARK: Private
    private let photo: Photo
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let initialPhotoLikeNumber = BehaviorSubject<Int>(value: 0)
    private let isPhotoLiked = BehaviorSubject<Bool>(value: false)

    // MARK: Init
    init(photo: Photo,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.photo = photo
        self.service = service
        self.sceneCoordinator = sceneCoordinator
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

        updated = photoStream
            .map { $0.updated ?? "" }
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
        
        photoDescription = photoStream
            .map { $0.description ?? "" }
    }
}
