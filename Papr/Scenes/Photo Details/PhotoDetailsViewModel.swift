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

protocol PhotoDetailsViewModelInput: PhotoViewModelInput {
    var dismissAction: CocoaAction { get }
    var moreAction: Action<[Any], Void> { get }
}

protocol PhotoDetailsViewModelOutput: PhotoViewModelOutput {
    var totalViews: Observable<String>! { get }
    var totalDownloads: Observable<String>! { get }
}

protocol PhotoDetailsViewModelType: PhotoViewModelType {
    var inputs: PhotoDetailsViewModelInput { get }
    var outputs: PhotoDetailsViewModelOutput { get }
}

class PhotoDetailsViewModel: PhotoViewModel,
                             PhotoDetailsViewModelType,
                             PhotoDetailsViewModelInput,
                             PhotoDetailsViewModelOutput {

    // MARK: Inputs & Outputs
    var inputs: PhotoDetailsViewModelInput { return self }
    override var photoViewModelInputs: PhotoViewModelInput { return inputs }

    var outputs: PhotoDetailsViewModelOutput { return self }
    override var photoViewModelOutputs: PhotoViewModelOutput { return outputs }

    // MARK: Inputs
    lazy var dismissAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            self.sceneCoordinator.pop(animated: true)
        }
    }()

    lazy var moreAction: Action<[Any], Void> = {
        Action<[Any], Void>  { [unowned self] items in
            return self.sceneCoordinator.transition(to: Scene.activity(items))
        }
    }()

    // MARK: Outputs
    var totalViews: Observable<String>!
    var totalDownloads: Observable<String>!

    override init(
        photo: Photo,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
        ) {

        super.init(photo: photo, service: service)

        totalViews = service.photo(withId: photo.id ?? "")
            .map { $0.views?.abbreviated }
            .unwrap()
            .catchErrorJustReturn("0")

        totalDownloads = service.photo(withId: photo.id ?? "")
            .map { $0.downloads?.abbreviated }
            .unwrap()
            .catchErrorJustReturn("0")
    }
}
