//
//  Constants+Color.swift
//  Papr
//
//  Created by Joan Disho on 03.10.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension Constants.Appearance {
    enum Color {
        static let iron = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        static let yellowZ = UIColor(red: 252.0/255.0, green: 197.0/255.0, blue: 6.0/255.0, alpha: 1.0)

        static var label: UIColor {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        }

        static var secondaryLabel: UIColor {
            if #available(iOS 13.0, *) {
                return .secondaryLabel
            } else {
                return .darkGray
            }
        }

        static var systemBackground: UIColor {
            if #available(iOS 13.0, *) {
                return .systemBackground
            } else {
                return .white
            }
        }

        static var customAccent: UIColor {
            if #available(iOS 13, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .secondarySystemBackground // grayish dark
                    } else {
                        return .systemBackground // true white
                    }
                }
            } else {
                return .white
            }
        }

        static var customAccent1: UIColor {
            if #available(iOS 13, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .systemBackground // true dark
                    } else {
                        return .secondarySystemBackground
                    }
                }
            } else {
                return .white
            }
        }
    }
}
