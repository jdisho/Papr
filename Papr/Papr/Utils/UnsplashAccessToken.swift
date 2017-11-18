//
//  UnsplashAccessToken.swift
//  Papr
//
//  Created by Joan Disho on 17.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

class UnsplashAccessToken {
    let clientID: String
    let accessToken: String
    
    init(clientID: String, accessToken: String) {
        self.clientID = clientID
        self.accessToken = accessToken
    }
    
    var description: String {
        return self.accessToken
    }
    
}
