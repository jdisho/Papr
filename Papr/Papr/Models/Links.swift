//
//  Links.swift
//  Papr
//
//  Created by Joan Disho on 19.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

struct Links {
    let selfLink: String?
    let html: String?
    let photos: String?
    let likes: String?
    let portfolio: String?
    let download: String?
    let downloadLocation: String?

}  

extension Links: Decodable {
    
    enum LinksCodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case photos
        case likes
        case portfolio
        case download
        case downloadLocation = "download_location"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LinksCodingKeys.self)

        selfLink = try container.decode(String.self, forKey: .selfLink)
        html = try? container.decode(String.self, forKey: .html)
        photos = try? container.decode(String.self, forKey: .photos)
        likes = try? container.decode(String.self, forKey: .likes)
        portfolio = try? container.decode(String.self, forKey: .portfolio)
        download = try? container.decode(String.self, forKey: .download)
        downloadLocation = try? container.decode(String.self, forKey: .downloadLocation)
    }
}
