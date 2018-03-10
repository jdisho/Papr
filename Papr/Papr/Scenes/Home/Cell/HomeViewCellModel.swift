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
    var photoDetailsAction: Action<Photo, Void> { get }
}

protocol HomeViewCellModelOutput: PhotoViewModelOutput {
    var userProfileImage: Observable<String>! { get }
    var fullname: Observable<String>! { get }
    var username: Observable<String>! { get }
    var smallPhoto: Observable<String>! { get }
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
    lazy var photoDetailsAction: Action<Photo, Void> = {
        return Action<Photo, Void> { photo in
            let viewModel = PhotoDetailsViewModel(photo: photo)
            return self.sceneCoordinator.transition(to: .photoDetails(viewModel), type: .modal)
        }
    }()

    // MARK: Output
    var userProfileImage: Observable<String>!
    var fullname: Observable<String>!
    var username: Observable<String>!
    var smallPhoto: Observable<String>!
    var updated: Observable<String>!

    // MARK: Init
    override init(photo: Photo,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        super.init(photo: photo, service: service)

        userProfileImage = photoStream
            .map { $0.user?.profileImage?.medium ?? "" }

        fullname = photoStream
            .map { $0.user?.fullName ?? "" }

        username = photoStream
            .map { "@\($0.user?.username ?? "")" }

        smallPhoto = photoStream
            .map { $0.urls?.small ?? "" }

        updated = photoStream
            .map { $0.updated ?? "" }
            .map { $0.toDate }
            .map { date -> String in
                guard let date = date else { return "" }
                return date.abbreviated
            }
    }
}
