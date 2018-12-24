//
//  NibIdentifiable.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit

protocol NibIdentifiable: class {
    static var nib: UINib { get }
}

extension NibIdentifiable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibIdentifiable where Self: UIView {
    static func initFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self
            else { fatalError("Couldn't find nib file for \(self)") }
        return view
    }
}

extension NibIdentifiable where Self: UITableView {
    static func initFromNib() -> Self {
        guard let tableView = nib.instantiate(withOwner: nil, options: nil).first as? Self
            else { fatalError("Couldn't find nib file for \(self)") }
        return tableView
    }
}

extension NibIdentifiable where Self: UICollectionView {
    static func initFromNib() -> Self {
        guard let collectionView = nib.instantiate(withOwner: nil, options: nil).first as? Self
            else { fatalError("Couldn't find nib file for \(self)") }
        return collectionView
    }
}

extension NibIdentifiable where Self: UIViewController {
    static func initFromNib() -> Self {
       return Self(nibName: nibIdentifier, bundle: nil)
    }
}

extension UIViewController: NibIdentifiable {
    static var nibIdentifier: String {
        return String(describing: self)
    }
}
