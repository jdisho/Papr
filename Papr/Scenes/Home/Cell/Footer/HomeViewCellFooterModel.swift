//
//  HomeViewCellFooterModel.swift
//  Papr
//
//  Created by Joan Disho on 28.04.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Photos

protocol HomeViewCellFooterModelInput {
    var likePhotoAction: Action<Photo, Photo> { get }
    var unlikePhotoAction: Action<Photo, Photo> { get }
    var downloadPhotoAction: Action<Photo, String> { get }
    var userCollectionsAction: Action<Photo, Void> { get }
    var writeImageToPhotosAlbumAction: Action<UIImage, Void> { get }
}
protocol HomeViewCellFooterModelOutput {
    var photo: Observable<Photo> { get }
    var likesNumber: Observable<String> { get }
    var isLikedByUser: Observable<Bool> { get }
}

protocol HomeViewCellFooterModelType {
    var inputs: HomeViewCellFooterModelInput { get }
    var outputs: HomeViewCellFooterModelOutput { get }
}

class HomeViewCellFooterModel: HomeViewCellFooterModelInput,
                               HomeViewCellFooterModelOutput,
                               HomeViewCellFooterModelType {

    var inputs: HomeViewCellFooterModelInput { return self }
    var outputs: HomeViewCellFooterModelOutput { return self }

    // MARK: Input
    lazy var likePhotoAction: Action<Photo, Photo> = {
        Action<Photo, Photo> { [unowned self] photo in
            return self.photoService.like(photo: photo)
                .flatMap { [unowned self] result -> Observable<Photo> in
                    switch result {
                    case let .success(photo):
                        return .just(photo)
                    case let .failure(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .other(message):
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
                    case let .failure(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .other(message):
                            self.alertAction.execute((title: "Upsss...", message: message))
                        }
                        return .empty()
                    }
            }
        }
    }()

    lazy var downloadPhotoAction: Action<Photo, String> = {
        Action<Photo, String> { [unowned self] photo in
            return self.photoService.photoDownloadLink(withId: photo.id ?? "")
                .flatMap { [unowned self] result -> Observable<String> in
                    switch result {
                    case let .success(link):
                        return .just(link)
                    case let .failure(error):
                        self.alertAction.execute((title: "Upsss...", message: error.errorDescription))
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
                    case let .failure(error):
                        switch error {
                        case .noAccessToken:
                            self.navigateToLogin.execute(())
                        case let .other(message):
                            self.alertAction.execute((title: "Upsss...", message: message))
                        }
                        return .empty()
                    }
            }
        }
    }()

    lazy var writeImageToPhotosAlbumAction: Action<UIImage, Void> = {
        Action<UIImage, Void> { [unowned self] image in
            self.photoLibrary.rx.authorizationStatus()
                .flatMap { status -> Observable<Void> in
                    guard status == .authorized else {
                        return .error(PhotoError.unauthorized)
                    }
                    return self.creationRequestForAsset(from: image)
            }
        }
    }()

    // MARK: Outputs
    let photo: Observable<Photo>
    let likesNumber: Observable<String>
    let isLikedByUser: Observable<Bool>

    // MARK: Private
    private let cache: Cache
    private let userService: UserServiceType
    private let photoService: PhotoServiceType
    private let photoLibrary: PHPhotoLibrary
    private let sceneCoordinator: SceneCoordinatorType
    private let bag = DisposeBag()

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

    init(photo: Photo,
         cache: Cache = Cache.shared,
         userService: UserServiceType = UserService(),
         photoService: PhotoServiceType = PhotoService(),
         photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.cache = cache
        self.photoService = photoService
        self.userService = userService
        self.photoLibrary = photoLibrary
        self.sceneCoordinator = sceneCoordinator

        self.photo = Observable.just(photo)
        let cachedPhoto = cache.getObject(ofType: Photo.self, withId: photo.id ?? "").unwrap()

        likesNumber = self.photo.merge(with: cachedPhoto)
            .map { $0.likes?.abbreviated }
            .unwrap()

        isLikedByUser = self.photo.merge(with: cachedPhoto)
            .map { $0.likedByUser }
            .unwrap()
    }

    private func creationRequestForAsset(from image: UIImage) -> Observable<Void> {
        let change = photoLibrary.rx.performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }.share()
        
        // error case
        change.materialize()
            .map { event -> Error? in
                switch event {
                case .error(let error): return error
                default: return nil
            }
        }.unwrap()
            .map { error -> (String, String) in
                switch error {
                case PhotoError.unauthorized:
                    return (title: "Upsss...",
                    message: "Photo can't be saved! Photo Libray access is denied ⚠️")
                default:
                    return (title: "Upsss...",
                    message: error.localizedDescription + "😕")
                }
        }.bind(to: alertAction.inputs)
        .disposed(by: bag)
        
        // success case
        change.map {
            (title: "Saved to Photos 🎉",
            message: "" )
        }.bind(to: alertAction.inputs)
        .disposed(by: bag)
        
        return change
    }
}
