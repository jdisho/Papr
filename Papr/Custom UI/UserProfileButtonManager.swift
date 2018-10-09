//
//  UserProfileButtonManager.swift
//  Papr
//
//  Created by Joan Disho on 22.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Nuke
import Action
import VanillaConstraints

class UserProfileButtonManager: UINavigationController {

    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let service: UserServiceType = UserService()
    private let sceneCoordiantor: SceneCoordinatorType = SceneCoordinator.shared
    private let disposeBag = DisposeBag()

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)

        configureNavigationBar()
    }

    private func configureNavigationBar() {
        let profileImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        profileImage.cornerRadius = Double(profileImage.frame.height / 2)

        var button = UIButton(frame: .zero)
        button.add(to: profileImage).size(profileImage.frame.size).pinToEdges()

        let profileImageBarButtonItem = UIBarButtonItem(customView: profileImage)
        button.rx.action = showUserProfileAction

        topViewController?.navigationItem.leftBarButtonItem = profileImageBarButtonItem

        service.getMe()
            .flatMap { result -> Observable<User> in
                switch result {
                case let .success(user):
                    return .just(user)
                case .error(_):
                    return .empty()
                }
            }
            .map { $0.profileImage?.medium }
            .unwrap()
            .mapToURL()
            .flatMap { UserProfileButtonManager.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: profileImage.rx.image)
            .disposed(by: disposeBag)
    }

    private lazy var showUserProfileAction: CocoaAction = {
        let viewModel = UserProfileViewModel()
        return CocoaAction { [unowned self] in
            self.sceneCoordiantor.transition(to: Scene.userProfile(viewModel))
        }
    }()
}
