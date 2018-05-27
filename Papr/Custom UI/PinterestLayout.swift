//
//  PinterestLayout.swift
//  Papr
//
//  Created by Joan Disho on 26.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@objc protocol PinterestLayoutDelegate: class {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
        ) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {

    // MARK: Delegate
    weak var delegate: PinterestLayoutDelegate!

    // MARK: Fileprivates
    fileprivate let numberOfColumns = 2
    fileprivate let cellPadding: CGFloat = 6
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    // MARK: Overrides
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()

        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let cellContentHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding + cellContentHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}

extension Reactive where Base: PinterestLayout {

    var delegate: DelegateProxy<PinterestLayout, PinterestLayoutDelegate> {
        return RxPinterestLayoutDelegateProxy.proxy(for: base)
    }

    var heightForCellAtIndexPath: ControlEvent<IndexPath> {
        let source = self.delegate
            .methodInvoked(#selector(PinterestLayoutDelegate.collectionView(_:heightForPhotoAtIndexPath:)))
            .map { a in
                return a[1] as! IndexPath
            }
        return ControlEvent(events: source)
    }
}

class RxPinterestLayoutDelegateProxy: DelegateProxy<PinterestLayout, PinterestLayoutDelegate>, DelegateProxyType {
    typealias ParentObject = PinterestLayout
    typealias Delegate = PinterestLayoutDelegate

    weak private(set) var pinterestLayout: PinterestLayout?

    init(pinterestLayout: ParentObject) {
        self.pinterestLayout = pinterestLayout
        super.init(parentObject: pinterestLayout, delegateProxy: RxPinterestLayoutDelegateProxy.self)
    }

    static func registerKnownImplementations() {}

    static func currentDelegate(for object: PinterestLayout) -> PinterestLayoutDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: PinterestLayoutDelegate?, to object: PinterestLayout) {
        object.delegate = delegate
    }
}


