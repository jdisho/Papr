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

class PhotoDetailsViewModel: PhotoViewModel {

    // MARK: Inputs
    /// sourcery:begin: input
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
    /// sourcery:end

    // MARK: Outputs
    /// sourcery:begin: output
    var totalViews: Observable<String>!
    var totalDownloads: Observable<String>!
    /// sourcery:end

    override init(
        photo: Photo,
        likedByUser: Bool,
        totalLikes: Int,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
        ) {

        super.init(
            photo: photo,
            likedByUser: likedByUser,
            totalLikes: totalLikes,
            service: service
        )

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
