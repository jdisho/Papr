//
//  PhotoDetailsViewController.swift
//  Papr
//
//  Created by Joan Disho on 03.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import Nuke
import RxNuke
import RxSwift
import Hero
import VanillaConstraints

class PhotoDetailsViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: PhotoDetailsViewModelType!

    // MARK: IBOutlets
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var totalViewsImageView: UIImageView!
    @IBOutlet var totalViewsLabel: UILabel!
    @IBOutlet var totalLikesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var totalDownloadsLabel: UILabel!
    @IBOutlet var downloadImageView: UIImageView!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var statsContainerView: UIView!
    @IBOutlet var dismissButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var statsContainerViewBottomConstraint: NSLayoutConstraint!

    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private let disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()
    private var isTouched = true
    private var scrollView: UIScrollView!
    private var photoImageView: UIImageView!
    private var tapGesture: UITapGestureRecognizer!
    private var doubleTapGesture: UITapGestureRecognizer!
    private var dismissGesture: UIPanGestureRecognizer!

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
            .map { $0.id }
            .unwrap()
            .bind(to: photoImageView.rx.heroId)
            .disposed(by: disposeBag)
        
        outputs.regularPhotoURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .orEmpty()
            .map { $0.image }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.photoSize
            .map { size -> CGFloat in
                let (width, height) = size
                return CGFloat(height * Double(UIScreen.main.bounds.width) / width)
            }
            .bind { [weak self] in
                self?.configureContentSize(withHeight: $0)
            }
            .disposed(by: disposeBag)

        outputs.likedByUser
            .map { $0 ? Papr.Appearance.Icon.heartFillSmall : Papr.Appearance.Icon.heartSmall }
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
            .bind { [weak self] in
                self?.likeButton.rx.bind(to: $0 ? inputs.unlikePhotoAction : inputs.likePhotoAction, input: $1)
            }
            .disposed(by: disposeBag)

        outputs.photoStream
            .map { $0.links?.html }
            .unwrap()
            .bind { [weak self] in
                guard let image = self?.photoImageView.image else { return }
                self?.moreButton.rx.bind(to: inputs.moreAction, input: [$0, image])
            }
            .disposed(by: disposeBag)
    }

    // MARK: UI
    private func configureAll() {
        likeButton.setImage(Papr.Appearance.Icon.heartSmall, for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.tintColor = .white

        let eyeImage = Papr.Appearance.Icon.eyeFillSmall
        let downloadImage = Papr.Appearance.Icon.squareAndArrowDownSmall
        totalViewsImageView.image = eyeImage
        downloadImageView.image = downloadImage
        if #available(iOS 13.0, *) {} else {
            totalViewsImageView.image = eyeImage.withRenderingMode(.alwaysTemplate)
            downloadImageView.image = downloadImage.withRenderingMode(.alwaysTemplate)
        }
        totalViewsImageView.tintColor = .white
        downloadImageView.tintColor = .white

        moreButton.setImage(Papr.Appearance.Icon.ellipsis, for: .normal)
        dismissButton.setImage(Papr.Appearance.Icon.close, for: .normal)
        dismissButton.imageView?.contentMode = .scaleAspectFit
        
        configureScrollView()
        configurePhotoImageView()
        configureTapGestures()
        configureDismissGesture()

        view.bringSubviewToFront(dismissButton)
        view.bringSubviewToFront(statsContainerView)
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
        scrollView.add(to: view).pinToEdges()
    }

    private func configurePhotoImageView() {
        photoImageView = UIImageView(frame: view.bounds)
        photoImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(photoImageView)
    }

    private func configureContentSize(withHeight height: CGFloat) {
        let bounds = view.bounds
        scrollView.frame = bounds
        let size = CGSize(
            width: UIScreen.main.bounds.width,
            height: height
        )
        photoImageView.frame = CGRect(origin: .zero, size: size)
        scrollView.contentSize = size
    }
    
    private func configureDismissGesture() {
        dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissController))
        view.addGestureRecognizer(dismissGesture)
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

    private func centerScrollViewIfNeeded() {
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
                    self.dismissButtonTopConstraint.constant = 16
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

    @objc private func zoomInOut(gestureRecognizer: UITapGestureRecognizer) {
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

    @objc private func zoomOut() {
        scrollView.setZoomScale(1, animated: true)
    }
    
    @objc private func dismissController() {
        if scrollView.zoomScale > 1 { return }
        
        let translation = dismissGesture.translation(in: nil)
        let progress = abs(translation.y / view.bounds.height) * 1.5
        switch dismissGesture.state {
            case .began:
                Hero.shared.defaultAnimation = .fade
                viewModel.inputs.dismissAction.execute(())
            case .changed:
                Hero.shared.update(progress)
                let currentPos = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
                Hero.shared.apply(modifiers: [.position(currentPos)], to: photoImageView)
            default:
                if progress + dismissGesture.velocity(in: nil).y / view.bounds.height > 0.3 {
                    Hero.shared.finish()
                } else {
                    viewModel.inputs.revertAction.execute(())
                    Hero.shared.cancel()
                }
        }
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

