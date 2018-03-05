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
    var dismissAction: CocoaAction { get }
}

protocol PhotoDetailsViewModelOutput {
    var photo: Observable<String> { get }
    var photoSizeCoef: Observable<Double> { get }
    var totalViews: Observable<String> { get }
    var totalLikes: Observable<String> { get }
    var totalDownloads: Observable<String> { get }
    var likedByUser: Observable<Bool> { get }
}

protocol PhotoDetailsViewModelType {
    var inputs: PhotoDetailsViewModelInput { get }
    var outputs: PhotoDetailsViewModelOutput { get }
}

class PhotoDetailsViewModel: PhotoDetailsViewModelType,
                             PhotoDetailsViewModelInput,
                             PhotoDetailsViewModelOutput {

    // MARK: Inputs & Outputs
    var inputs: PhotoDetailsViewModelInput { return self }
    var outputs: PhotoDetailsViewModelOutput { return self }

    // MARK: Inputs
    lazy var dismissAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            self.sceneCoordinator.pop(animated: true)
        }
    }()

    // MARK: Outputs
    let photo: Observable<String>
    let photoSizeCoef: Observable<Double>
    let totalViews: Observable<String>
    let totalLikes: Observable<String>
    let totalDownloads: Observable<String>
    let likedByUser: Observable<Bool>

    // MARK: Private
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType

    init(photo: Photo,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
        let photoStream = service
            .photo(withId: photo.id ?? "")

        self.photo = photoStream
            .map { $0.urls?.regular ?? "" }

        photoSizeCoef = photoStream
            .map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                return Double(height * Int(UIScreen.main.bounds.width) / width)
        }

        totalViews = photoStream
            .map { $0.views?.abbreviated ?? "0" }

        totalLikes = photoStream
            .map { $0.likes?.abbreviated ?? "0" }

        totalDownloads = photoStream
            .map { $0.downloads?.abbreviated ?? "0" }

        likedByUser = photoStream
            .map { $0.likedByUser ?? false }
    }
}
