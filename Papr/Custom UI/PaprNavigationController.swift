//
//  PaprNavigationController.swift
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

class PaprNavigationController: UINavigationController {

    // MARK: Properties

    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()

    private var service: UserServiceType!
    private var sceneCoordiantor: SceneCoordinatorType!

    private lazy var showUserProfileAction: CocoaAction = {
        let viewModel = UserProfileViewModel()
        return CocoaAction { [unowned self] in
            self.sceneCoordiantor.transition(to: Scene.userProfile(viewModel))
        }
    }()

    // MARK: Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    init(rootViewController: UIViewController,
        service: UserServiceType = UserService(),
        sceneCoordiantor: SceneCoordinatorType = SceneCoordinator.shared) {
        super.init(rootViewController: rootViewController)

        self.service = service
        self.sceneCoordiantor = sceneCoordiantor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)

        configureNavigationBar()
    }

    // MARK: Helpers

    private func configureNavigationBar() {
        navigationBar.tintColor = .black
        navigationBar.isTranslucent = false

        let profileImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        profileImage.isHidden = true
        profileImage.cornerRadius = Double(profileImage.frame.height / 2)

        var button = UIButton(frame: .zero)
        button.add(to: profileImage).size(profileImage.frame.size).pinToEdges()

        let profileImageBarButtonItem = UIBarButtonItem(customView: profileImage)
        button.rx.action = showUserProfileAction

        topViewController?.navigationItem.leftBarButtonItem = profileImageBarButtonItem
        topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        service.getMe()
            .flatMap { result -> Observable<User> in
                switch result {
                case let .success(user):
                    profileImage.isHidden = false
                    return .just(user)
                case .error:
                    return .empty()
                }
            }
            .map { $0.profileImage?.medium }
            .unwrap()
            .mapToURL()
            .flatMap { PaprNavigationController.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: profileImage.rx.image)
            .disposed(by: disposeBag)
    }
}
