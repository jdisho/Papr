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
    var photoDetailsAction: CocoaAction { get }
}

protocol HomeViewCellModelOutput: PhotoViewModelOutput {
    var userProfileImage: Observable<String> { get }
    var fullname: Observable<String> { get }
    var username: Observable<String> { get }
    var smallPhoto: Observable<String> { get }
    var updated: Observable<String> { get }
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
    lazy var photoDetailsAction: CocoaAction = {
        return CocoaAction { [unowned self] in
            let viewModel = PhotoDetailsViewModel(photo: self.photo)
            return self.sceneCoordinator.transition(to: .photoDetails(viewModel), type: .modal)
        }
    }()

    // MARK: Output
    let userProfileImage: Observable<String>
    let fullname: Observable<String>
    let username: Observable<String>
    let smallPhoto: Observable<String>
    let updated: Observable<String>

    // MARK: Init
    override init(photo: Photo,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        let photoStream = Observable.just(photo)

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
                guard let roundedDate = date?.since(Date(), in: .minute).rounded() else { return "" }
                if roundedDate >= 60.0 && roundedDate <= 24 * 60.0 {
                    return "\(Int(date!.since(Date(), in: .hour).rounded()))h"
                } else if roundedDate >= 24 * 60.0 && roundedDate <= 30 * 24 * 60 {
                    return "\(Int(date!.since(Date(), in: .week).rounded()))w"
                } else if roundedDate >= 30 * 24 * 60 && roundedDate <= 365 * 24 * 60 {
                    return "\(Int(date!.since(Date(), in: .month).rounded()))m"
                } else if roundedDate >= 365 * 24 * 60 {
                    return "\(Int(date!.since(Date(), in: .year).rounded()))y"
                }
                return "\(Int(roundedDate))min"
            }

        super.init(photo: photo, service: service)
    }
}
