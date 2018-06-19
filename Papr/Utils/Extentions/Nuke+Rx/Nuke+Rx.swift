//
//  Nuke+Rx.swift
//  Papr
//
//  Created by Joan Disho on 04.02.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import Nuke
import RxSwift

extension ImagePipeline: ReactiveCompatible {}

public extension Reactive where Base: ImagePipeline {

    public func loadImage(with url: URL) -> Single<ImageResponse> {
        return self.loadImage(with: ImageRequest(url: url))
    }

    public func loadImage(with request: ImageRequest) -> Single<ImageResponse> {
        return Single<ImageResponse>.create { single in
            if let image = self.cachedResponse(for: request) {
                single(.success(image)) // return syncrhonously
                return Disposables.create() // nop
            } else {
                let task = self.base.loadImage(with: request) { response, error in
                    if let response = response {
                        single(.success(response))
                    } else {
                        single(.error(error ?? ImagePipeline.Error.processingFailed)) // error always non-nil
                    }
                }
                return Disposables.create { task.cancel() }
            }
        }
    }

    private func cachedResponse(for request: ImageRequest) -> ImageResponse? {
        guard request.memoryCacheOptions.isReadAllowed else { return nil }
        return base.configuration.imageCache?.cachedResponse(for: request)
    }
}
