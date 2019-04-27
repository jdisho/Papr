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
import Photos

protocol HomeViewCellModelInput {
    var likePhotoAction: Action<Photo, Photo> { get }
    var unlikePhotoAction: Action<Photo, Photo> { get }
    var photoDetailsAction: Action<Photo, Photo> { get }
    var downloadPhotoAction: Action<Photo, String> { get }
    var userCollectionsAction: Action<Photo, Void> { get }
    var writeImageToPhotosAlbumAction: Action<UIImage, Void> { get }
}

protocol HomeViewCellModelOutput {
    var photoStream: Observable<Photo> { get }
    var smallPhoto: Observable<String> { get }
    var regularPhoto: Observable<String> { get }
    var fullPhoto: Observable<String> { get }
    var photoSize: Observable<(Double, Double)> { get }
    var totalLikes: Observable<String> { get }
    var likedByUser: Observable<Bool> { get }
    var headerViewModelType: HomeViewCellHeaderModelType { get }
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
    lazy var likePhotoAction: Action<Photo, Photo> = {
        Action<Photo, Photo> { [unowned self] photo in
            return self.photoService.like(photo: photo)
                .flatMap { [unowned self] result -> Observable<Photo> in
                    switch result {
                    case let .success(photo):
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

    lazy var unlikePhotoAction: Action<Photo, Photo> = {
        Action<Photo, Photo> { [unowned self] photo in
            return self.photoService.unlike(photo: photo)
                .flatMap { [unowned self] result -> Observable<Photo> in
                    switch result {
                    case let .success(photo):
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

    lazy var photoDetailsAction: Action<Photo, Photo> = {
        Action<Photo, Photo> { [unowned self] photo in
            let viewModel = PhotoDetailsViewModel(photo: photo)
            self.sceneCoordinator.transition(to: Scene.photoDetails(viewModel))
            return .just(photo)
        }
    }()

    lazy var downloadPhotoAction: Action<Photo, String> = {
        Action<Photo, String> { [unowned self] photo in
            return self.photoService.photoDownloadLink(withId: photo.id ?? "")
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

    lazy var userCollectionsAction: Action<Photo, Void> = {
        Action<Photo, Void> { [unowned self] photo in
           return self.userService.getMe()
            .flatMap { result -> Observable<Void> in
                    switch result {
                    case let .success(user):
                        let viewModel = AddToCollectionViewModel(loggedInUser: user, photo: photo)
                        return self.sceneCoordinator.transition(to: Scene.addToCollection(viewModel))
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

    // MARK: Output
    let photoStream: Observable<Photo>
    let smallPhoto: Observable<String>
    let regularPhoto: Observable<String>
    let fullPhoto: Observable<String>
    let photoSize: Observable<(Double, Double)>
    let totalLikes: Observable<String>
    let likedByUser: Observable<Bool>

    lazy var headerViewModelType: HomeViewCellHeaderModelType = {
        return HomeViewCellHeaderModel(photo: photo)
    }()

    // MARK: Private
    private let photo: Photo
    private let cache: Cache
    private let userService: UserServiceType
    private let photoService: PhotoServiceType
    private let photoLibrary: PHPhotoLibrary
    private let sceneCoordinator: SceneCoordinatorType

    private lazy var alertAction: Action<(title: String, message: String), Void> = {
        Action<(title: String, message: String), Void> { [unowned self] (title, message) in
            let alertViewModel = AlertViewModel(
                title: title,
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()

    private lazy var navigateToLogin: CocoaAction = {
        CocoaAction { [unowned self] message in
            let viewModel = LoginViewModel()
            return self.sceneCoordinator.transition(to: Scene.login(viewModel))
        }
    }()

    // MARK: Init
    init(photo: Photo,
        cache: Cache = Cache.shared,
        userService: UserServiceType = UserService(),
        photoService: PhotoServiceType = PhotoService(),
        photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.photo = photo
        self.cache = cache
        self.photoService = photoService
        self.userService = userService
        self.photoLibrary = photoLibrary
        self.sceneCoordinator = sceneCoordinator

        let cachedPhotoStream = cache.getObject(ofType: Photo.self, withId: photo.id ?? "").unwrap()

        photoStream = Observable.just(photo)

        smallPhoto = photoStream
            .map { $0.urls?.small }
            .unwrap()

        regularPhoto = photoStream
            .map { $0.urls?.regular }
            .unwrap()

        fullPhoto = photoStream
            .map { $0.urls?.full }
            .unwrap()

        photoSize = Observable.combineLatest(
            photoStream.map { $0.width }.unwrap().map { Double($0) },
            photoStream.map { $0.height }.unwrap().map { Double($0) }
        )

        totalLikes = photoStream.merge(with: cachedPhotoStream)
            .map { $0.likes?.abbreviated }
            .unwrap()

        likedByUser = photoStream.merge(with: cachedPhotoStream)
            .map { $0.likedByUser }
            .unwrap()
    }

    private func creationRequestForAsset(from image: UIImage) {
        photoLibrary.performChanges({
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
