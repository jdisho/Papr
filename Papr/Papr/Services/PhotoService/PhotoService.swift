//
//  PhotoService.swift
//  Papr
//
//  Created by Joan Disho on 08.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct PhotoService: PhotoServiceType {

    private var provider: MoyaProvider<UnsplashAPI>
    
    init(provider: MoyaProvider<UnsplashAPI> = MoyaProvider<UnsplashAPI>()) {
        self.provider = provider
    }
    
    func photos(byPageNumber pageNumber: Int?, orderBy: OrderBy?) -> Observable<[Photo]?> {
        return provider.rx
            .request(.photos(page: pageNumber, 
                             perPage: Constants.photosPerPage, 
                             orderBy: orderBy))
            .asObservable()
            .mapOptional([Photo].self)
    }
    
}
