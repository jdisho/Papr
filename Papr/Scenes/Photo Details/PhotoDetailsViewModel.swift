//
//  PhotoDetailsViewModel.swift
//  Papr
//
//  Created by Joan Disho on 03.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol PhotoDetailsViewModelInput {
    var likePhotoAction: Action<Photo, Photo> { get }
    var unlikePhotoAction: Action<Photo, Photo> { get }
    var dismissAction: CocoaAction { get }
    var revertAction: CocoaAction { get }
    var moreAction: Action<[Any], Void> { get }
}

protocol PhotoDetailsViewModelOutput {
    var photoStream: Observable<Photo> { get }
    var regularPhotoURL: Observable<URL> { get }
    var photoSize: Observable<(Double, Double)> { get }
    var totalLikes: Observable<String> { get }
    var likedByUser: Observable<Bool> { get }
    var totalViews: Observable<String> { get }
    var totalDownloads: Observable<String> { get }
}

protocol PhotoDetailsViewModelType {
    var inputs: PhotoDetailsViewModelInput { get }
    var outputs: PhotoDetailsViewModelOutput { get }
}

final class PhotoDetailsViewModel: PhotoDetailsViewModelType, PhotoDetailsViewModelInput, PhotoDetailsViewModelOutput {

    // MARK: Inputs & Outputs
    var inputs: PhotoDetailsViewModelInput { return self }
    var outputs: PhotoDetailsViewModelOutput { return self }

    // MARK: Inputs
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

    lazy var dismissAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            self.popCancelable = self.sceneCoordinator.pop(animated: true).subscribe()
            return .empty()
        }
    }()
    
    lazy var revertAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            self.popCancelable?.dispose()
            return .empty()
        }
    }()

    lazy var moreAction: Action<[Any], Void> = {
        Action<[Any], Void>  { [unowned self] items in
            return self.sceneCoordinator.transition(to: Scene.activity(items))
        }
    }()

    // MARK: Outputs
    let regularPhotoURL: Observable<URL>
    let photoSize: Observable<(Double, Double)>
    let totalLikes: Observable<String>
    let likedByUser: Observable<Bool>
    let photoStream: Observable<Photo>
    let totalViews: Observable<String>
    let totalDownloads: Observable<String>

    // MARK: Privates
    private let cache: Cache
    private let photoService: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private var popCancelable: Disposable?

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
        photoService: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.cache = cache
        self.photoService = photoService
        self.sceneCoordinator = sceneCoordinator

        let cachedPhotoStream = cache.getObject(ofType: Photo.self, withId: photo.id ?? "").unwrap()

        photoStream = Observable.just(photo)

        regularPhotoURL = photoStream
            .map { $0.urls?.regular }
            .unwrap()
            .mapToURL()

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

        let photo = photoService.photo(withId: photo.id ?? "").share()

        totalViews = photo
            .map { $0.views?.abbreviated }
            .unwrap()
            .catchErrorJustReturn("0")

        totalDownloads = photo
            .map { $0.downloads?.abbreviated }
            .unwrap()
            .catchErrorJustReturn("0")
    }
}
