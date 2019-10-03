//
//  Constants+Icon.swift
//  Papr
//
//  Created by Joan Disho on 03.10.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension Constants.Appearance {
    enum Icon {
        @available(iOS 13.0, *)
        private static var symbolConfigurationMedium: UIImage.SymbolConfiguration {
            return UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        }

        @available(iOS 13.0, *)
        private static var symbolConfigurationSmall: UIImage.SymbolConfiguration {
            return UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .small)
        }

        static var arrowUpRight: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "arrow.up.right", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "up")
        }

        static var bookmark: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "bookmark", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "bookmark-border-black")
        }

        @available(iOS 13.0, *)
        static let ellipsis = UIImage(systemName: "ellipsis")!

        static var eyeFillSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "eye.fill", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "eye-white")
        }

        static var flame: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "flame", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "hot")
        }

        static var heartSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "favorite-border-black")
        }

        static var heartFillSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart.fill", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "favorite-black")
        }

        static var heartMedium: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "favorite-border-black")
        }

        static var heartFillMedium: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart.fill", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "favorite-black")
        }

        static var magnifyingGlass: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(
                    systemName: "magnifyingglass",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
            }
            return UIImage(imageLiteralResourceName: "search-white")
        }

        static var photo: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(
                    systemName: "photo",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
            }
            return UIImage(imageLiteralResourceName: "photo-white")
        }

        static var rectangleGrid2x2Fill: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(
                    systemName: "rectangle.grid.2x2.fill",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
            }
            return UIImage(imageLiteralResourceName: "collections-white")
        }


        static var squareAndArrowDownMedium: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "square.and.arrow.down", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "down-black")
        }

        static var squareAndArrowDownSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "square.and.arrow.down", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "down-black")
        }
    }
}

