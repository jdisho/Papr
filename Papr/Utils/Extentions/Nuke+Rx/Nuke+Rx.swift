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

    // MARK: Observables
    public func loadImage(with url: URL) -> Observable<ImageResponse> {
        return self.load(with: ImageRequest(url: url)).orEmpty()
    }

    public func loadImage(with request: ImageRequest) -> Observable<ImageResponse> {
        return self.load(with: request).orEmpty()
    }

    // MARK: Privates

    private func load(with imageRequest: ImageRequest) -> Single<ImageResponse> {
        return Single<ImageResponse>.create { single in
            if let image = self.cachedResponse(for: imageRequest) {
                single(.success(image)) // return syncrhonously
                return Disposables.create() // nop
            } else {
                let task = self.base.loadImage(with: imageRequest) { response, error in
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

private extension PrimitiveSequence where Trait == SingleTrait {
    func orEmpty() -> Observable<Element> {
        return asObservable()
            .catchError { _ in .empty() }
    }
}



