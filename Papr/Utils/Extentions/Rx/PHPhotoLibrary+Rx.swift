//
//  PHPhotoLibrary+Rx.swift
//  Papr
//
//  Created by Piotr on 19/10/2019.
//  Copyright © 2019 Joan Disho. All rights reserved.
//

import Photos
import RxSwift

enum PhotoError: Error {
    case unknown
    case unauthorized
}

extension Reactive where Base: PHPhotoLibrary {
    func performChanges(_ changeBlock: @escaping () -> Void) -> Observable<Void> {
        return Observable.create { observer in
            self.base.performChanges(changeBlock) { success, error in
                guard success else {
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onError(PhotoError.unknown)
                    }
                    return
                }
                
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
    
    func authorizationStatus() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { observer in
            PHPhotoLibrary.requestAuthorization { status in
                observer.onNext(status)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
