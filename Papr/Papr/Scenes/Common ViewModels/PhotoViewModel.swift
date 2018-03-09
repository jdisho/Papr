//
//  PhotoViewModel.swift
//  Papr
//
//  Created by Joan Disho on 09.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol PhotoViewModelInput {
    var likePhotoAction: Action<Photo, Photo> { get }
    var unlikePhotoAction: Action<Photo, Photo> { get }
    var alertAction: Action<String, Void> { get }
}

protocol PhotoViewModelOutput {
    var regularPhoto: Observable<String> { get }
    var photoSizeCoef: Observable<Double> { get }
    var totalLikes: Observable<String> { get }
    var likedByUser:  Observable<Bool> { get }
}

protocol PhotoViewModelType {
    var photoViewModelInputs: PhotoViewModelInput { get }
    var photoViewModelOutputs: PhotoViewModelOutput { get }
    var photo: Photo { get set }
}

class PhotoViewModel: PhotoViewModelType,
                      PhotoViewModelInput,
                      PhotoViewModelOutput {

    // MARK: Inputs & Outputs
    var photoViewModelInputs: PhotoViewModelInput { return self }
    var photoViewModelOutputs: PhotoViewModelOutput { return self }

    // MARK: Input
    lazy var likePhotoAction: Action<Photo, Photo>  = {
        return Action<Photo, Photo> { photo in
            self.service
                .like(photoWithId: photo.id ?? "")
                .map { $0.photo }
                .unwrap()
                .map { [unowned self] photo in
                    return self.update(photo: photo)
                }
        }
    }()

    lazy var unlikePhotoAction: Action<Photo, Photo>  = {
        return Action<Photo, Photo> { photo in
            self.service
                .unlike(photoWithId: photo.id ?? "")
                .map { $0.photo }
                .unwrap()
                .map { [unowned self] photo in
                     return self.update(photo: photo)
                }
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

    // MARK: Output
    let regularPhoto: Observable<String>
    let photoSizeCoef: Observable<Double>
    let totalLikes: Observable<String>
    let likedByUser: Observable<Bool>

    var photo: Photo
    let service: PhotoServiceType
    let sceneCoordinator: SceneCoordinatorType
    let photoTotalLikesProperty = BehaviorSubject<Int>(value: 0)
    let isPhotoLikedProperty = BehaviorSubject<Bool>(value: false)

    func update(photo: Photo) -> Photo {
        self.photo = photo
        photoTotalLikesProperty.onNext(photo.likes ?? 0)
        isPhotoLikedProperty.onNext(photo.likedByUser ?? false)
        return photo
    }

    // MARK: Init
    init(photo: Photo,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.photo = photo
        self.service = service
        self.sceneCoordinator = sceneCoordinator

        let photoStream = Observable.just(photo)

        regularPhoto = photoStream
            .map { $0.urls?.regular ?? "" }

        photoSizeCoef = photoStream
            .map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                return Double(height * Int(UIScreen.main.bounds.width) / width)
        }

        photoTotalLikesProperty.onNext(photo.likes ?? 0)
        totalLikes = photoTotalLikesProperty
            .map { likes in
                guard likes != 0 else { return "" }
                return likes.abbreviated
        }

        isPhotoLikedProperty.onNext(photo.likedByUser ?? false)
        likedByUser = isPhotoLikedProperty.asObservable()
    }
}
