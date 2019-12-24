//
//  Papr+Appearance.swift
//  Papr
//
//  Created by Joan Disho on 24.12.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension Papr {
    enum Appearance {
          enum Color {
              static let iron = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
              static let yellowZ = UIColor(red: 252.0/255.0, green: 197.0/255.0, blue: 6.0/255.0, alpha: 1.0)
          }
      }
}

extension Papr.Appearance {
    enum Style {
        static let imageCornersRadius: CGFloat = 8.0
    }

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
            return UIImage(imageLiteralResourceName: "arrow.up.right")
        }

        static var bookmark: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "bookmark", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "bookmark.regular.medium")
        }

        static var eyeFillSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "eye.fill", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "eye.fill.regular.small")
        }

        static var flame: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "flame", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "flame.regular.medium")
        }

        static var heartSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "heart.regular.small")
        }

        static var heartFillSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart.fill", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "heart.fill.regular.small")
        }

        static var heartMedium: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "heart.regular.medium")
        }

        static var heartFillMedium: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "heart.fill", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "heart.fill.regular.medium")
        }

        static var magnifyingGlass: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
            }
            return UIImage(imageLiteralResourceName: "magnifyingglass.medium.small")
        }

        static var photo: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
            }
            return UIImage(imageLiteralResourceName: "photo.medium.small")
        }

        static var rectangleGrid2x2Fill: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "rectangle.grid.2x2.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
            }
            return UIImage(imageLiteralResourceName: "rectangle.grid.2x2.fill.medium.small")
        }


        static var squareAndArrowDownMedium: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "square.and.arrow.down", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "square.and.arrow.down.regular.medium")
        }

        static var squareAndArrowDownSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "square.and.arrow.down", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "square.and.arrow.down.regular.small")
        }

        static var doneWhiteSmall: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "checkmark", withConfiguration: symbolConfigurationSmall)!
            }
            return UIImage(imageLiteralResourceName: "checkmark.regular.small")
        }

        static var addMedium: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "plus", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "plus.regular.medium")
        }

        static var close: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "xmark", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "xmark.regular.medium")
        }

        static var ellipsis: UIImage {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "ellipsis", withConfiguration: symbolConfigurationMedium)!
            }
            return UIImage(imageLiteralResourceName: "ellipsis.regular.medium")
        }

    }

}
