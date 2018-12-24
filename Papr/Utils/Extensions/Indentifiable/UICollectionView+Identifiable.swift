//
//  UICollectionView+Identifiable.swift
//  Papr
//
//  Created by Joan Disho on 22.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register<C: UICollectionViewCell>(cellType: C.Type) where C: ClassIdentifiable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseId)
    }

    func register<C: UICollectionViewCell>(cellType: C.Type) where C: NibIdentifiable & ClassIdentifiable {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseId)
    }

    func dequeueReusableCell<C: UICollectionViewCell>(withCellType type: C.Type = C.self, forIndexPath indexPath: IndexPath) -> C where C: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.reuseId, for: indexPath) as? C
            else { fatalError("Couldn't dequeue a UICollectionViewCell with identifier: \(type.reuseId)") }
        return cell
    }
}

