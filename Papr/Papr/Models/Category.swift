//
//  Category.swift
//  Papr
//
//  Created by Joan Disho on 19.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

struct Category {
    let id: Int?
    let title: String?
    let photoCount: Int?
    let links: Links?
}

extension Category: Decodable {
    
    private enum CategoryCodingKeys: String, CodingKey {
        case id
        case title = "exposure_time"
        case photoCount = "photo_count"
        case links
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CategoryCodingKeys.self)
        
        id = try? container.decode(Int.self, forKey: .id)
        title = try? container.decode(String.self, forKey: .title)
        photoCount = try? container.decode(Int.self, forKey: .photoCount)
        links = try? container.decode(Links.self, forKey: .links)
    }
}

