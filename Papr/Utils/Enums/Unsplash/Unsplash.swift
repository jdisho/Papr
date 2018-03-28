//
//  Unsplash.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import TinyNetworking

enum Unsplash {

    /// Get the user's profile
    case getMe

    /// Update the current user’s profile
    case updateMe(
        username: String?,
        firstName: String?,
        lastName: String?,
        email: String?,
        url: String?,
        location: String?,
        bio: String?,
        instagramUsername:
        String?)

    /// Get a user’s public profile
    case userProfile(
        username: String,
        width: Int?,
        height: Int?)

    /// Get a user’s portfolio link
    case userPortfolio(username: String)

    /// List a user’s photos
    case userPhotos(
        username: String,
        page: Int?,
        perPage: Int?,
        orderBy: OrderBy?)

    /// List a user’s liked photos
    case userLikedPhotos(
        username: String,
        page: Int?,
        perPage: Int?,
        orderBy: OrderBy?)

    /// List a user’s collections
    case userCollections(
        username:String,
        page: Int?,
        perPage: Int?)

    /// Get a user’s statistics
    case userStatistics(
        username: String,
        resolution: Resolution?,
        quantity: Int?)

    /// Get the list of all photos
    case photos(
        page: Int?,
        perPage: Int?,
        orderBy: OrderBy?)

    /// Get the list of the curated photos
    case curatedPhotos(
        page: Int?,
        perPage: Int?,
        orderBy: OrderBy?)

    /// Retrieve a single photo.
    case photo(id: String)

    /// Get a random photo
    case randomPhoto(
        collectionsID: [String]?,
        isFeatured: Bool?,
        username: String?,
        query: String?,
        width: Int?,
        height: Int?,
        orientation: Orientation?,
        count: Int?)

    /// Get a photo’s statistics
    case photoStatistics(
        id: String,
        resolution: Resolution?,
        quantity: Int?)

    /// Retrieve a single photo’s download link
    case photoDownloadLink(id: String)

    /// Like a photo on behalf of the logged-in user
    case likePhoto(id: String)

    /// Remove a user’s like of a photo.
    case unlikePhoto(id: String)

    /// Get photo results for a query
    case searchPhotos(
        query: String,
        page: Int?,
        perPage: Int?,
        collectionID: String?,
        orientation: Orientation?)

    /// Get collection results for a query
    case searchCollections(
        query: String,
        page: Int?,
        perPage: Int?)

    /// Get user results for a query
    case searchUsers(
        query: String,
        page: Int?,
        perPage: Int?)

    /// Get a list of all collections
    case collections(
        page: Int?,
        perPage: Int?)

    /// Get a list of featured collections
    case featuresCollections(
        page: Int?,
        perPage: Int?)

    /// Get a list of curated collections
    case curatedCollections(
        page: Int?,
        perPage: Int?)

    /// Retrieve a collection
    case collection(id: String)
    
    /// Retrieve a curated collection
    case curatedCollection(id: String)
    
    /// Retrieve a related collection
    case relatedCollections(id: String)
    
    /// Retrieve a collection’s photos
    case collectionPhotos(
        id: String,
        page: Int?,
        perPage: Int?)
    
    /// Retrieve a curated collection’s photos
    case curatedCollectionPhotos(
        id: String,
        page: Int?,
        perPage: Int?)
    
    /// Create a new collection
    case createCollection(
        title: String,
        description: String?,
        isPrivate: Bool?)
    
    /// Update an existing collection
    case updateCollection(
        id: String,
        title: String?,
        description: String?,
        isPrivate: Bool?)

    /// Delete an existing collection
    case deleteCollection(id: String)
    
    /// Add a photo to a collection
    case addPhotoToCollection(
        collectionID: String,
        photoID: String)
    
    /// Remove a photo from a collection
    case removePhotoFromCollection(
        collectionID: String,
        photoID: String)
    
    // MARK: - TODO: Support these cases

    // id(required)
    // case updatePhoto(String)

}

extension Unsplash: TargetType  {

    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var endpoint: String {
        switch self {
        case .getMe, .updateMe:
            return "/me"
        case let .userProfile(username):
            return "/users/\(username)"
        case let .userPortfolio(username):
            return "/users/\(username)/portfolio"
        case let .userPhotos(username):
            return "/users/\(username)/photos"
        case let .userLikedPhotos(username):
            return "/users/\(username)/likes"
        case let .userCollections(username):
            return "/users/\(username)/collections"
        case let .userStatistics(username):
            return "/users/\(username)/statistics"
        case .photos:
           return "/photos"
        case .curatedPhotos:
            return "/photos/curated"
        case let .photo(id):
            return "/photos/\(id)"
        case .randomPhoto:
            return "/photos/random"
        case let .photoStatistics(id, _, _):
            return "/photos/\(id)/statistics"
        case let .photoDownloadLink(id):
            return "/photos/\(id)/download"
        case let .likePhoto(id):
            return "/photos/\(id)/like"
        case let .unlikePhoto(id):
            return "/photos/\(id)/like"
        case .searchPhotos:
          return "/search/photos"
        case .searchCollections:
            return "/search/collections"
        case .searchUsers:
            return "/search/users"
        case .collections, .createCollection:
            return "/collections"
        case .featuresCollections:
            return "/collections/featured"
        case .curatedCollections:
            return "/collections/curated"
        case let .collection(id):
            return "/collections/\(id)"
        case let .curatedCollection(id):
            return "/collections/curated\(id)"
        case let .collectionPhotos(id, _, _):
           return "/collections/\(id)/photos"
        case let .curatedCollectionPhotos(id, _, _):
            return "/collections/curated/\(id)/photos"
        case let .relatedCollections(id):
            return "/collections/\(id)/related"
        case let .updateCollection(id, _, _, _):
            return "/collections\(id)"
        case let .deleteCollection(id):
            return "/collections/\(id)"
        case let .addPhotoToCollection(collectionID, _):
            return "/collections/\(collectionID)/add"
        case let .removePhotoFromCollection(collectionID, _):
            return "/collections/\(collectionID)/remove"
        }
    }

    var parameters: [String : String] {
        return [:]
    }

    var resource: ResourceType {
        switch self {
        case .likePhoto:
            return SimpleResource<LikeUnlike>(.post(()))
        default:
            return SimpleResource<[Photo]>()
        }
    }

    var headers: [String : String] {
        let token = UserDefaults.standard.string(forKey: UnsplashSettings.clientID.string)

        return ["Authorization": "Bearer \(token!)"]
    }
}
