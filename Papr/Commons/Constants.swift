//
//  Constants.swift
//  Papr
//
//  Created by Joan Disho on 22.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static let photosPerPage = 10

    enum Appearance {
        enum Color {
            static let iron = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
            static let yellowZ = UIColor(red: 252.0/255.0, green: 197.0/255.0, blue: 6.0/255.0, alpha: 1.0)
        }

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
                    return UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
                }
                return UIImage(imageLiteralResourceName: "search-white")
            }

            static var photo: UIImage {
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
                }
                return UIImage(imageLiteralResourceName: "photo-white")
            }

            static var rectangleGrid2x2Fill: UIImage {
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "rectangle.grid.2x2.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))!
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

    enum UnsplashSettings {
        static let host = "unsplash.com"
        static let callbackURLScheme = "papr://"
        static let clientID = UnsplashSecrets.clientID
        static let clientSecret = UnsplashSecrets.clientSecret
        static let authorizeURL = "https://unsplash.com/oauth/authorize"
        static let tokenURL = "https://unsplash.com/oauth/token"
        static let redirectURL = "papr://unsplash"

        enum UnsplashSecrets {

            static let clientID = UnsplashSecrets.environmentVariable(named: "UNSPLASH_CLIENT_ID") ?? ""
            static let clientSecret = UnsplashSecrets.environmentVariable(named: "UNSPLASH_CLIENT_SECRET") ?? ""

            private static func environmentVariable(named: String) -> String? {
                guard let infoDictionary = Bundle.main.infoDictionary, let value = infoDictionary[named] as? String else {
                    print("‼️ Missing Environment Variable: '\(named)'")
                    return nil
                }
                return value
            }
        }
    }
}
