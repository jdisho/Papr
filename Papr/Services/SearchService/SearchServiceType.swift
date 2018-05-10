//
//  SearchServiceType.swift
//  Papr
//
//  Created by Joan Disho on 10.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchServiceType {
    func searchPhotos(with query: String, pageNumber: Int) -> Observable<PhotosResult>

    func searchCollections(with query: String, pageNumber: Int) -> Observable<PhotoCollectionsResult>

    func searchUsers(with query: String, pageNumber: Int) -> Observable<UsersResult>
}
