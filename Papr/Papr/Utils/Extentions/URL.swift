//
//  URL.swift
//  Papr
//
//  Created by Joan Disho on 21.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

extension URL {
    
    func value(for queryKey: String) -> String? {
        let stringURL = self.absoluteString
        guard let items = URLComponents(string: stringURL)?.queryItems else { return nil }
        for item in items where item.name == queryKey {
            return item.value
        }
        return nil
    }
}
