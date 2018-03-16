//
//  UnsplashAPI.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

enum UnsplashAPI {

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

extension UnsplashAPI {

    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: URL {
        switch self {
        case .getMe, .updateMe:

            return baseURL.appendingPathComponent("/me")

        case let .userProfile(username):

            return  baseURL.appendingPathComponent("/users/\(username)")

        case let .userPortfolio(username):

            return  baseURL.appendingPathComponent("/users/\(username)/portfolio")

        case let .userPhotos(username):

            return  baseURL.appendingPathComponent("/users/\(username)/photos")

        case let .userLikedPhotos(username):

            return  baseURL.appendingPathComponent("/users/\(username)/likes")

        case let .userCollections(username):

            return  baseURL.appendingPathComponent("/users/\(username)/collections")

        case let .userStatistics(username):

            return  baseURL.appendingPathComponent("/users/\(username)/statistics")

        case .photos:

           return  baseURL.appendingPathComponent("/photos")

        case .curatedPhotos:

            return  baseURL.appendingPathComponent("/photos/curated")

        case let .photo(id):

            return  baseURL.appendingPathComponent("/photos/\(id)")

        case .randomPhoto:

            return  baseURL.appendingPathComponent("/photos/random")

        case let .photoStatistics(id, _, _):

            return  baseURL.appendingPathComponent("/photos/\(id)/statistics")

        case let .photoDownloadLink(id):

            return  baseURL.appendingPathComponent("/photos/\(id)/download")

        case let .likePhoto(id):

            return  baseURL.appendingPathComponent("/photos/\(id)/like")

        case let .unlikePhoto(id):

            return  baseURL.appendingPathComponent("/photos/\(id)/like")

        case .searchPhotos:

          return  baseURL.appendingPathComponent("/search/photos")

        case .searchCollections:

            return  baseURL.appendingPathComponent("/search/collections")

        case .searchUsers:

            return  baseURL.appendingPathComponent("/search/users")

        case .collections, .createCollection:

            return  baseURL.appendingPathComponent("/collections")

        case .featuresCollections:

            return  baseURL.appendingPathComponent("/collections/featured")

        case .curatedCollections:

            return  baseURL.appendingPathComponent("/collections/curated")

        case let .collection(id):

            return  baseURL.appendingPathComponent("/collections/\(id)")

        case let .curatedCollection(id):

            return  baseURL.appendingPathComponent("/collections/curated\(id)")

        case let .collectionPhotos(id, _, _):

           return  baseURL.appendingPathComponent("/collections/\(id)/photos")

        case let .curatedCollectionPhotos(id, _, _):

            return  baseURL.appendingPathComponent("/collections/curated/\(id)/photos")

        case let .relatedCollections(id):

            return  baseURL.appendingPathComponent("/collections/\(id)/related")

        case let .updateCollection(id, _, _, _):

            return  baseURL.appendingPathComponent("/collections\(id)")

        case let .deleteCollection(id):

            return  baseURL.appendingPathComponent("/collections/\(id)")

        case let .addPhotoToCollection(collectionID, _):

            return  baseURL.appendingPathComponent("/collections/\(collectionID)/add")

        case let .removePhotoFromCollection(collectionID, _):

            return  baseURL.appendingPathComponent("/collections/\(collectionID)/remove")
    
        }
    }
    
//    var method: HttpMethod<Body> {
//        switch self {
//        case .getMe,
//             .userProfile,
//             .userPortfolio,
//             .userPhotos,
//             .userLikedPhotos,
//             .userCollections,
//             .userStatistics,
//             .photos,
//             .curatedPhotos,
//             .photo,
//             .randomPhoto,
//             .photoStatistics,
//             .photoDownloadLink,
//             .searchPhotos,
//             .searchCollections,
//             .searchUsers,
//             .collections,
//             .featuresCollections,
//             .curatedCollections,
//             .collection,
//             .curatedCollection,
//             .collectionPhotos,
//             .curatedCollectionPhotos,
//             .relatedCollections:
//            return .get
//        case let .likePhoto,
//             .createCollection,
//             .addPhotoToCollection:
//            return .post
//        case .updateCollection,
//             .updateMe:
//            return .put
//        case .unlikePhoto,
//             .removePhotoFromCollection,
//             .deleteCollection:
//            return .delete
//        }
//    }

//    var task: Task {
//        switch self {
//        case let .updateMe(username, firstName, lastName, email,
//                           url, location, bio, instagramUsername):
//
//            var params: [String: Any] = [:]
//            params["username"] = username
//            params["first_name"] = firstName
//            params["last_name"] = lastName
//            params["email"] = email
//            params["url"] = url
//            params["location"] = location
//            params["bio"] = bio
//            params["instagram_username"] = instagramUsername
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .userProfile(_, width, height):
//
//            var params: [String: Any] = [:]
//            params["w"] = width
//            params["h"] = height
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .userPhotos(_, pageNumber, photosPerPage, orderBy),
//             let .userLikedPhotos(_, pageNumber, photosPerPage, orderBy),
//             let .photos(pageNumber, photosPerPage, orderBy),
//             let .curatedPhotos(pageNumber, photosPerPage, orderBy):
//
//            var params: [String: Any] = [:]
//            params["page"] = pageNumber
//            params["per_page"] = photosPerPage
//            params["order_by"] = orderBy
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .userStatistics(_, resolution, quantity),
//             let .photoStatistics(_, resolution, quantity):
//
//            var params: [String: Any] = [:]
//            params["resolution"] = resolution?.value
//            params["quantity"] = quantity
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .randomPhoto(collectionsID, isFeatured, username,
//                          query, width, height, orientation, count):
//
//            var params: [String: Any] = [:]
//            params["collections"] = collectionsID
//            params["featured"] = isFeatured
//            params["username"] = username
//            params["query"] = query
//            params["w"] = width
//            params["h"] = height
//            params["orientation"] = orientation?.value
//            params["count"] = count
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .userCollections(_, pageNumber, photosPerPage),
//             let .collections(pageNumber, photosPerPage),
//             let .featuresCollections(pageNumber, photosPerPage),
//             let .curatedCollections(pageNumber, photosPerPage),
//             let .collectionPhotos(_, pageNumber, photosPerPage),
//             let .curatedCollectionPhotos(_, pageNumber, photosPerPage):
//
//            var params: [String: Any] = [:]
//            params["page"] = pageNumber
//            params["per_page"] = photosPerPage
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .searchCollections(query, pageNumber, photosPerPage),
//             let .searchUsers(query, pageNumber, photosPerPage):
//
//            var params: [String: Any] = [:]
//            params["query"] = query
//            params["page"] = pageNumber
//            params["per_page"] = photosPerPage
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .searchPhotos(query, pageNumber, photosPerPage, collections, orientation):
//
//            var params: [String: Any] = [:]
//            params["query"] = query
//            params["page"] = pageNumber
//            params["per_page"] = photosPerPage
//            params["collections"] = collections
//            params["orientation"] = orientation?.value
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .createCollection(title, description, isPrivate):
//
//            var params: [String: Any] = [:]
//            params["title"] = title
//            params["description"] = description
//            params["private"] = isPrivate
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .updateCollection(_, title, description, isPrivate):
//
//            var params: [String: Any] = [:]
//            params["title"] = title
//            params["description"] = description
//            params["private"] = isPrivate
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        case let .addPhotoToCollection(_, photoID),
//             let .removePhotoFromCollection(_, photoID):
//            var params: [String: Any] = [:]
//            params["photo_id"] = photoID
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//
//        default:
//            return .requestPlain
//        }
//    }

    
}
