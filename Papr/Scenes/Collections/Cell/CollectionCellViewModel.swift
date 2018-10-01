//
//  CollectionCellViewModel.swift
//  Papr
//
//  Created by Joan Disho on 05.09.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift

protocol CollectionCellViewModelInput {}
protocol CollectionCellViewModelOutput {
    var smallPhotoURL: Observable<String> { get }
    var regularPhotoURL: Observable<String> { get }
    var mediumUserProfilePic: Observable<String> { get }
    var largeUserProfilePic: Observable<String> { get }
    var username: Observable<String> { get }
    var title: Observable<String> { get }
}
protocol CollectionCellViewModelType {
    var input: CollectionCellViewModelInput { get }
    var output: CollectionCellViewModelOutput { get }
}

class CollectionCellViewModel: CollectionCellViewModelType,
                                CollectionCellViewModelInput,
                                CollectionCellViewModelOutput {

    // MARK: Input & Output
    var input: CollectionCellViewModelInput { return self }
    var output: CollectionCellViewModelOutput { return self }

    // MARK: Input

    // MARK: Output
    let smallPhotoURL: Observable<String>
    let regularPhotoURL: Observable<String>
    let mediumUserProfilePic: Observable<String>
    let largeUserProfilePic: Observable<String>
    let username: Observable<String>
    let title: Observable<String>

    // MARK: Private

    // MARK: Init
    init(photoCollection: PhotoCollection) {
        let photoCollectionStream = Observable.just(photoCollection)

        smallPhotoURL = photoCollectionStream
            .map { $0.coverPhoto?.urls?.small }
            .unwrap()

        regularPhotoURL = photoCollectionStream
            .map { $0.coverPhoto?.urls?.regular }
            .unwrap()

        mediumUserProfilePic = photoCollectionStream
            .map { $0.user?.profileImage?.medium }
            .unwrap()

        largeUserProfilePic = photoCollectionStream
            .map { $0.user?.profileImage?.large }
            .unwrap()

        title = photoCollectionStream
            .map { $0.title }
            .unwrap()

        username = photoCollectionStream
            .map { ($0.user?.firstName ?? "") + " " + ($0.user?.lastName ?? "") }

    }
}
