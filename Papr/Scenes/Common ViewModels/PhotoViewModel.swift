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
    var likePhotoAction: Action<Photo, LikeUnlikePhotoResult> { get }
    var unlikePhotoAction: Action<Photo, LikeUnlikePhotoResult> { get }
    var downloadPhotoAction: Action<Photo, DownloadPhotoResult> { get }
}

protocol PhotoViewModelOutput {
    var photoStream: Observable<Photo>! { get }
    var regularPhoto: Observable<String>! { get }
    var photoSizeCoef: Observable<Double>! { get }
    var totalLikes: Observable<String>! { get }
    var likedByUser: Observable<Bool>! { get }
    var photoDownloadLink: Observable<String?>! { get }
}

protocol PhotoViewModelType {
    var photoViewModelInputs: PhotoViewModelInput { get }
    var photoViewModelOutputs: PhotoViewModelOutput { get }
    var alertAction: Action<(title: String, message: String), Void> { get }
}

class PhotoViewModel: PhotoViewModelType,
                      PhotoViewModelInput,
                      PhotoViewModelOutput {

    // MARK: Inputs & Outputs
    var photoViewModelInputs: PhotoViewModelInput { return self }
    var photoViewModelOutputs: PhotoViewModelOutput { return self }
    
    lazy var alertAction: Action<(title: String, message: String), Void> = {
        Action<(title: String, message: String), Void> { [unowned self] (title, message) in
            let alertViewModel = AlertViewModel(
                title: title,
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(
                to: .alert(alertViewModel),
                type: .alert)
        }
    }()


    // MARK: Input
    lazy var likePhotoAction: Action<Photo, LikeUnlikePhotoResult>  = {
        Action<Photo, LikeUnlikePhotoResult> { photo in
            self.service.like(photo: photo)
                .do(onNext: { [unowned self] result in
                    switch result {
                    case let .success(photo):
                        self.update(photo: photo)
                    case let .error(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .error(message):
                            self.alertAction.execute((title: "Upsss...", message: message))
                        }
                    }
                })
        }
    }()

    lazy var unlikePhotoAction: Action<Photo, LikeUnlikePhotoResult>  = {
        Action<Photo, LikeUnlikePhotoResult> { photo in
            self.service.unlike(photo: photo)
                .do(onNext: { [unowned self] result in
                    switch result {
                    case let .success(photo):
                        self.update(photo: photo)
                    case let .error(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .error(message):
                            self.alertAction.execute((title: "Upsss...", message: message))
                        }
                    }
                })
        }
    }()

    lazy var downloadPhotoAction: Action<Photo, DownloadPhotoResult> = {
        Action<Photo, DownloadPhotoResult> { photo in
            self.service.photoDownloadLink(withId: photo.id ?? "")
                .flatMap { [unowned self] result -> Observable<DownloadPhotoResult> in
                    switch result {
                    case let .success(link):
                        self.photoDownloadLinkProperty.onNext(link)
                    case let.error(message):
                        self.alertAction.execute((title: "Upsss...", message: message))
                    }
                    return .empty()
                }
        }
    }()

    // MARK: Output
    var regularPhoto: Observable<String>!
    var photoSizeCoef: Observable<Double>!
    var totalLikes: Observable<String>!
    var likedByUser: Observable<Bool>!
    var photoStream: Observable<Photo>!
    var photoDownloadLink: Observable<String?>!

    let service: PhotoServiceType
    let sceneCoordinator: SceneCoordinatorType

    // MARK: Private
    private let photoStreamProperty = PublishSubject<Photo>()
    private let photoDownloadLinkProperty = BehaviorSubject<String?>(value: nil)

    private lazy var navigateToLogin: CocoaAction = {
        CocoaAction { [unowned self] message in
            let viewModel = LoginViewModel()
            return self.sceneCoordinator.transition(
                to: Scene.login(viewModel),
                type: .modal)
        }
    }()

    private func update(photo: Photo) {
        photoStreamProperty.onNext(photo)
    }

    // MARK: Init
    init(photo: Photo,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
        photoStream = Observable.just(photo)

        regularPhoto = photoStream
            .map { $0.urls?.regular ?? "" }

        photoSizeCoef = photoStream
            .map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                Double(height * Int(UIScreen.main.bounds.width) / width)
        }

        totalLikes = Observable.merge(photoStream, photoStreamProperty)
            .map { $0.likes ?? 0 }
            .map { likes in
                guard likes != 0 else { return "" }
                return likes.abbreviated
        }

        likedByUser = Observable.merge(photoStream, photoStreamProperty)
            .map { $0.likedByUser ?? false }

        photoDownloadLink = photoDownloadLinkProperty.asObservable()
    }
}
