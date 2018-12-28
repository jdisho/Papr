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
import Photos

protocol PhotoViewModelInput {
    var likePhotoAction: Action<Photo, Photo> { get }
    var unlikePhotoAction: Action<Photo, Photo> { get }
    var downloadPhotoAction: Action<Photo, String> { get }
    var writeImageToPhotosAlbumAction: Action<UIImage, Void> { get }
}

protocol PhotoViewModelOutput {
    var photoStream: Observable<Photo>! { get }
    var regularPhoto: Observable<String>! { get }
    var photoSize: Observable<(Double, Double)>! { get }
    var totalLikes: Observable<String>! { get }
    var likedByUser: Observable<Bool>! { get }
}

protocol PhotoViewModelType {
    var photoViewModelInputs: PhotoViewModelInput { get }
    var photoViewModelOutputs: PhotoViewModelOutput { get }
}

class PhotoViewModel: PhotoViewModelType,
                      PhotoViewModelInput,
                      PhotoViewModelOutput {

    // MARK: Inputs & Outputs
    var photoViewModelInputs: PhotoViewModelInput { return self }
    var photoViewModelOutputs: PhotoViewModelOutput { return self }

    // MARK: Input
    lazy var likePhotoAction: Action<Photo, Photo>  = {
        Action<Photo, Photo> { photo in
            return self.service.like(photo: photo)
                .flatMap { result -> Observable<Photo> in
                    switch result {
                    case let .success(photo):
                        self.photoStreamProperty.onNext(photo)
                        return .just(photo)
                    case let .error(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .error(message):
                            self.alertAction.execute((title: "Upsss...", message: message))
                        }
                        return .empty()
                    }
                }
        }
    }()

    lazy var unlikePhotoAction: Action<Photo, Photo>  = {
        Action<Photo, Photo> { photo in
            return self.service.unlike(photo: photo)
                .flatMap { result -> Observable<Photo> in
                    switch result {
                    case let .success(photo):
                        self.photoStreamProperty.onNext(photo)
                        return .just(photo)
                    case let .error(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .error(message):
                            self.alertAction.execute((title: "Upsss...", message: message))
                        }
                        return .empty()
                    }
                }
        }
    }()

    lazy var downloadPhotoAction: Action<Photo, String> = {
        Action<Photo, String> { photo in
            return self.service.photoDownloadLink(withId: photo.id ?? "")
                .flatMap { [unowned self] result -> Observable<String> in
                    switch result {
                    case let .success(link):
                        return .just(link)
                    case let.error(message):
                        self.alertAction.execute((title: "Upsss...", message: message))
                        return .empty()
                    }
                }
        }
    }()

    lazy var writeImageToPhotosAlbumAction: Action<UIImage, Void> = {
        Action<UIImage, Void> { image in
            PHPhotoLibrary.requestAuthorization { [unowned self] authorizationStatus in
                if authorizationStatus == .authorized {
                    self.creationRequestForAsset(from: image)
                } else if authorizationStatus == .denied {
                    self.alertAction.execute((
                        title: "Upsss...",
                        message: "Photo can't be saved! Photo Libray access is denied ⚠️"))
                }
            }
            return .empty()
        }
    }()

    lazy var alertAction: Action<(title: String, message: String), Void> = {
        Action<(title: String, message: String), Void> { [unowned self] (title, message) in
            let alertViewModel = AlertViewModel(
                title: title,
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()

    lazy var navigateToLogin: CocoaAction = {
        CocoaAction { [unowned self] message in
            let viewModel = LoginViewModel()
            return self.sceneCoordinator.transition(to: Scene.login(viewModel))
        }
    }()

    // MARK: Output
    var regularPhoto: Observable<String>!
    var photoSize: Observable<(Double, Double)>!
    var totalLikes: Observable<String>!
    var likedByUser: Observable<Bool>!
    var photoStream: Observable<Photo>!

    let service: PhotoServiceType
    let sceneCoordinator: SceneCoordinatorType

    // MARK: Private

    private let photoStreamProperty = BehaviorSubject<Photo?>(value: nil)

    // MARK: Init
    init(photo: Photo,
         likedByUser: Bool,
         totalLikes: Int,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator

        photoStream = Observable.just(photo)

        regularPhoto = photoStream
            .map { $0.urls?.regular }
            .unwrap()

        photoSize = Observable.combineLatest(
            photoStream.map { $0.width }.unwrap().map { Double($0) },
            photoStream.map { $0.height }.unwrap().map { Double($0) }
        )

        self.totalLikes = Observable.combineLatest(
            photoStreamProperty.asObservable().map { $0?.likes },
            Observable.just(totalLikes))
            .map { serverLikes, cachedLikes -> Int in
                guard let serverLikes = serverLikes else { return cachedLikes }
                return serverLikes
            }.map { $0.abbreviated }


        self.likedByUser = Observable.combineLatest(
            photoStreamProperty.asObservable().map { $0?.likedByUser },
            Observable.just(likedByUser))
            .map { serverLikedByUser, cachedLikedByUser -> Bool in
                guard let serverLikedByUser = serverLikedByUser else { return cachedLikedByUser }
                return serverLikedByUser
            }

    }

    // MARK: Helpers

    private func creationRequestForAsset(from image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { [unowned self] success, error in
            if success {
                self.alertAction.execute((
                    title: "Saved to Photos 🎉",
                    message: "" ))
            }
            else if let error = error {
                self.alertAction.execute((
                    title: "Upsss...",
                    message: error.localizedDescription + "😕"))
            }
            else {
                self.alertAction.execute((
                    title: "Upsss...",
                    message: "Unknown error 😱"))
            }
        })
    }
}
