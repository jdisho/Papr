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

protocol HomeViewCellModelInput: PhotoViewModelInput {
    var photoDetailsAction: Action<Photo, Photo> { get }
    var userCollectionsAction: Action<Photo, Void> { get }
}

protocol HomeViewCellModelOutput: PhotoViewModelOutput {
    var userProfileImage: Observable<String>! { get }
    var fullname: Observable<String>! { get }
    var username: Observable<String>! { get }
    var smallPhoto: Observable<String>! { get }
    var fullPhoto: Observable<String>! { get }
    var updated: Observable<String>! { get }
}

protocol HomeViewCellModelType: PhotoViewModelType {
    var inputs: HomeViewCellModelInput { get }
    var outputs: HomeViewCellModelOutput { get }
}

class HomeViewCellModel: PhotoViewModel,
                         HomeViewCellModelType,
                         HomeViewCellModelInput, 
                         HomeViewCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: HomeViewCellModelInput { return self }
    override var photoViewModelInputs: PhotoViewModelInput { return inputs }

    var outputs: HomeViewCellModelOutput { return self }
    override var photoViewModelOutputs: PhotoViewModelOutput { return outputs }

    // MARK: Input
    lazy var photoDetailsAction: Action<Photo, Photo> = {
        return Action<Photo, Photo> { [unowned self] photo in
            let viewModel = PhotoDetailsViewModel(
                photo: photo,
                likedByUser: self.isLikedByUser,
                totalLikes: self.likesNumber
            )
            self.sceneCoordinator.transition(to: Scene.photoDetails(viewModel))
            return .just(photo)
        }
    }()

    lazy var userCollectionsAction: Action<Photo, Void> = {
        return Action<Photo, Void> { [unowned self] photo in
           return self.userService.getMe().share()
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

    // MARK: Output
    var userProfileImage: Observable<String>!
    var fullname: Observable<String>!
    var username: Observable<String>!
    var smallPhoto: Observable<String>!
    var fullPhoto: Observable<String>!
    var updated: Observable<String>!

    // MARK: Private
    private let userService: UserServiceType
    private let isLikedByUser: Bool
    private let likesNumber: Int

    // MARK: Init
    override init(
        photo: Photo,
        likedByUser: Bool,
        totalLikes: Int,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
        ) {

        self.userService = UserService()
        isLikedByUser = likedByUser
        likesNumber = totalLikes

        super.init(
            photo: photo,
            likedByUser: likedByUser,
            totalLikes: totalLikes,
            service: service
        )

        userProfileImage = photoStream
            .map { $0.user?.profileImage?.medium }
            .unwrap()

        fullname = photoStream
            .map { $0.user?.fullName }
            .unwrap()

        username = photoStream
            .map { "@\($0.user?.username ?? "")" }

        smallPhoto = photoStream
            .map { $0.urls?.small }
            .unwrap()

        fullPhoto = photoStream
            .map { $0.urls?.full }
            .unwrap()

        updated = photoStream
            .map { $0.updated ?? "" }
            .map { $0.toDate }
            .map { date -> String in
                guard let date = date else { return "" }
                return date.abbreviated
            }
    }
}
