//
//  Papr+Error.swift
//  Papr
//
//  Created by Joan Disho on 24.12.19.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Foundation

extension Papr {
    enum Error: LocalizedError {
        case noAccessToken
        case other(message: String)

        var errorDescription: String {
            switch self {
            case .noAccessToken:
                return "Please provide the access token."
            case let .other(message: message):
                return message
            }
        }
    }
}
