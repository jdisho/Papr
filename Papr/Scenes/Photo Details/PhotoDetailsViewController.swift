//
//  PhotoDetailsViewController.swift
//  Papr
//
//  Created by Joan Disho on 03.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import Nuke
import RxSwift
import Hero

class PhotoDetailsViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: PhotoDetailsViewModelType!

    // MARK: IBOutlets
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var totalViewsLabel: UILabel!
    @IBOutlet var totalLikesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var totalDownloadsLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var statsContainerView: UIView!
    @IBOutlet var dismissButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var statsContainerViewBottomConstraint: NSLayoutConstraint!

    // MARK: Private
    private static let nukeManager = Nuke.Manager.shared
    private let disposeBag = DisposeBag()
    private var isTouched = true
    private var scrollView: UIScrollView!
    private var photoImageView: UIImageView!
    private var tapGesture: UITapGestureRecognizer!
    private var doubleTapGesture: UITapGestureRecognizer!

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAll()
        showHideOverlays(withDelay: 0.5)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillLayoutSubviews() {
        centerScrollViewIfNeeded()
    }

     // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        let this = PhotoDetailsViewController.self

        dismissButton.rx.action = inputs.dismissAction

        outputs.photoStream
            .map { $0.id ?? "" }
            .bind(to: photoImageView.rx.heroId)
            .disposed(by: disposeBag)

        outputs.regularPhoto
            .flatMap { this.nukeManager.loadImage(with: $0).orEmpty }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.photoSizeCoef
            .map { CGFloat($0) }
            .subscribe { result in
                guard let height = result.element else { return }
                self.configureContentSize(withHeight: height)
            }
            .disposed(by: disposeBag)

        outputs.likedByUser
            .map { $0 ? #imageLiteral(resourceName: "favorite-white") : #imageLiteral(resourceName: "favorite-border-white") }
            .bind(to: likeButton.rx.image())
            .disposed(by: disposeBag)

        outputs.totalViews
            .bind(to: totalViewsLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.totalLikes
            .bind(to: totalLikesLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.totalDownloads
            .bind(to: totalDownloadsLabel.rx.text)
            .disposed(by: disposeBag)

        Observable.combineLatest(outputs.likedByUser, outputs.photoStream)
            .subscribe { result in
                guard let result = result.element else { return }
                let (likedByUser, photo) = result
                if likedByUser {
                    self.likeButton.rx
                        .bind(to: inputs.unlikePhotoAction, input: photo)
                } else {
                    self.likeButton.rx
                        .bind(to: inputs.likePhotoAction, input: photo)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureAll() {
        configureScrollView()
        configurePhotoImageView()
        configureTapGestures()

        view.bringSubview(toFront: dismissButton)
        view.bringSubview(toFront: statsContainerView)
    }

    private func configureTapGestures() {
        tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(showHideOverlays(withDelay:)))

        tapGesture.addTarget(self,
            action: #selector(zoomOut))

        doubleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(zoomInOut(gestureRecognizer:)))

        doubleTapGesture.addTarget(self,
            action: #selector(hideOverlays))

        tapGesture.numberOfTapsRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2

        tapGesture.delegate = self
        doubleTapGesture.delegate = self

        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(doubleTapGesture)
    }

    private func configureScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3
        scrollView.contentMode = .center
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: 0).isActive = true

        scrollView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 0).isActive = true

        scrollView.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 0).isActive = true

        scrollView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: 0).isActive = true
    }

    private func configurePhotoImageView() {
        photoImageView = UIImageView(frame: view.bounds)
        photoImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(photoImageView)
    }

    private func configureContentSize(withHeight height: CGFloat) {
        let bounds = view.bounds
        scrollView.frame = bounds
        let size: CGSize
        let containerSize = CGSize(width: bounds.width, height: bounds.height)
        if containerSize.width / containerSize.height < view.bounds.size.width / height {
            size = CGSize(
                width: containerSize.width,
                height: containerSize.width * height / view.bounds.size.width
            )
        } else {
            size = CGSize(
                width: containerSize.height * view.bounds.size.width / height,
                height: containerSize.height
            )
        }
        photoImageView.frame = CGRect(origin: .zero, size: size)
        scrollView.contentSize = size
    }


    private func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = photoImageView.frame.size.height / scale
        zoomRect.size.width  = photoImageView.frame.size.width  / scale
        let newCenter = photoImageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func centerScrollViewIfNeeded() {
        var inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if scrollView.contentSize.height < scrollView.bounds.height {
            let insetV = (scrollView.bounds.height - scrollView.contentSize.height)/2
            inset.top += insetV
            inset.bottom = insetV
        }
        if scrollView.contentSize.width < scrollView.bounds.width {
            let insetV = (scrollView.bounds.width - scrollView.contentSize.width)/2
            inset.left = insetV
            inset.right = insetV
        }
        scrollView.contentInset = inset
    }

    @objc private func showHideOverlays(withDelay delay: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                if self.isTouched {
                    self.statsContainerViewBottomConstraint.constant = 0
                    self.dismissButtonTopConstraint.constant = 32
                    self.isTouched = false
                } else {
                    self.hideOverlays()
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc private func hideOverlays() {
        self.statsContainerViewBottomConstraint.constant = 132
        self.dismissButtonTopConstraint.constant = -100
        self.isTouched = true
    }



    @objc func zoomInOut(gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(
                to: zoomRect(
                    forScale: scrollView.maximumZoomScale,
                    withCenter: gestureRecognizer.location(in: gestureRecognizer.view)),
                animated: true)
        } else {
            zoomOut()
        }
    }

    @objc func zoomOut() {
        scrollView.setZoomScale(1, animated: true)
    }

}

// MARK: UIScrollViewDelegate

extension PhotoDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewIfNeeded()
    }
}

// MARK: PhotoDetailsViewController

extension PhotoDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
        return gestureRecognizer == self.tapGesture &&
            otherGestureRecognizer == self.doubleTapGesture
    }
}
