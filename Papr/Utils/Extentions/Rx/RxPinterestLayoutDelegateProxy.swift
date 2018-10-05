//
//  RxPinterestLayoutDelegateProxy.swift
//  Papr
//
//  Created by Joan Disho on 05.10.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxPinterestLayoutDelegateProxy: DelegateProxy<PinterestLayout, PinterestLayoutDelegate>, PinterestLayoutDelegate, DelegateProxyType {

    weak private(set) var pinterestLayout: PinterestLayout?
    var sizes:[IndexPath: CGSize] = [:]

    init(pinterestLayout: PinterestLayout) {
        self.pinterestLayout = pinterestLayout
        super.init(parentObject: pinterestLayout, delegateProxy: RxPinterestLayoutDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxPinterestLayoutDelegateProxy(pinterestLayout: $0) }
    }

    static func currentDelegate(for object: PinterestLayout) -> PinterestLayoutDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: PinterestLayoutDelegate?, to object: PinterestLayout) {
        object.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return sizes[indexPath] ?? CGSize(width: 100, height: 100)
    }
}
