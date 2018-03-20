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
import RxCocoa

enum NukeError: Error {
    case urlError
}

// MARK: Loading

/// Loads images.
public protocol Loading {
    func loadImage(with request: Nuke.Request) -> RxSwift.Single<Image>
}

public extension Loading {
    
    /// Loads an image with the given string.
    public func loadImage(with string: String) -> RxSwift.Single<Image> {
        guard let url = URL(string: string) else { return Single.error(NukeError.urlError) }
        return loadImage(with: Nuke.Request(url: url))
    }
    
    /// Loads an image with the given url.
    public func loadImage(with url: URL) -> RxSwift.Single<Image> {
        return loadImage(with: Nuke.Request(url: url))
    }
    
    /// Loads an image with the given url request.
    public func loadImage(with urlRequest: URLRequest) -> RxSwift.Single<Image> {
        return loadImage(with: Nuke.Request(urlRequest: urlRequest))
    }
}

extension Nuke.Manager: Loading {
    
    /// Loads an image with the given request.
    public func loadImage(with request: Nuke.Request) -> RxSwift.Single<Image> {
        return Single<Image>.create { observer in
            if let image = self.cachedImage(for: request) {
                observer(.success(image))
                return Disposables.create() // nop
            } else {
                return _loadImage(loader: self, request: request, observer: observer)
            }
        }
    }
    
    private func cachedImage(for request: Request) -> Image? {
        guard request.memoryCacheOptions.readAllowed else { return nil }
        return cache?[request]
    }
}

extension Nuke.Loader: Loading {
    
    /// Loads an image with the given request.
    public func loadImage(with request: Nuke.Request) -> RxSwift.Single<Image> {
        return Single<Image>.create {
            _loadImage(loader: self, request: request, observer: $0)
        }
    }
}

fileprivate func _loadImage<T: Nuke.Loading>(loader: T, request: Nuke.Request, observer: @escaping Single<Image>.SingleObserver) -> Disposable {
    let cts = CancellationTokenSource()
    loader.loadImage(with: request, token: cts.token) { result in
        switch result {
        case let .success(image): observer(.success(image))
        case let .failure(error): observer(.error(error))
        }
    }
    return Disposables.create { cts.cancel() }
}

// MARK: RxSwift Extensions

extension RxSwift.PrimitiveSequence where Trait == RxSwift.SingleTrait, Element == Nuke.Image {
    
    // The reason why it's declared on RxSwift.Single<Image> is to
    // avoid polluting RxSwift namespace.
    /// Dismiss errors and complete the sequence instead
    /// - returns: An observable sequence that never errors and completes when
    /// an error occurs in the underlying sequence
    public var orEmpty: Observable<Element> {
        return self.asObservable().catchError { _ in
            return .empty()
        }
    }
}
