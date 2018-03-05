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

    // MARK: Private
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType

    init(photo: Photo,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {

        self.service = service
        self.sceneCoordinator = sceneCoordinator
        let photoStream = Observable.just(photo)

        self.photo = photoStream
            .map { $0.urls?.regular ?? "" }

        photoSizeCoef = photoStream
            .map { (width: $0.width ?? 0, height: $0.height ?? 0) }
            .map { (width, height) -> Double in
                return Double(height * Int(UIScreen.main.bounds.width) / width)
        }

        let photoStatistics = service
            .photoStatistics(withId: photo.id ?? "")

        totalViews = photoStatistics
            .map { $0.views?.total?.abbreviated ?? "0" }

        totalLikes = photoStream
            .map { $0.likes?.abbreviated ?? "0" }

        totalDownloads = photoStatistics
            .map { $0.downloads?.total?.abbreviated ?? "0" }
    }
}
