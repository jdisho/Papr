//
//  Unsplash.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import Moya

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
        orderBy: OrderBy?,
        showStats: Bool?,
        resolution: Resolution?,
        quantity: Int?)

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
    case photo(
        id: String,
        width: Int?,
        height: Int?,
        rect: [Int]?)

    /// Get a random photo
    case randomPhoto(
        collections: [String]?,
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
        collections: [String]?,
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
    case featuredCollections(
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
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("FAILED: https://api.unsplash.com")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getMe, .updateMe:
            return "/me"
        case let .userProfile(param):
            return "/users/\(param.username)"
        case let .userPortfolio(username):
            return "/users/\(username)/portfolio"
        case let .userPhotos(param):
            return "/users/\(param.username)/photos"
        case let .userLikedPhotos(param):
            return "/users/\(param.username)/likes"
        case let .userCollections(param):
            return "/users/\(param.username)/collections"
        case let .userStatistics(param):
            return "/users/\(param.username)/statistics"
        case .photos:
           return "/photos"
        case .curatedPhotos:
            return "/photos/curated"
        case let .photo(param):
            return "/photos/\(param.id)"
        case .randomPhoto:
            return "/photos/random"
        case let .photoStatistics(param):
            return "/photos/\(param.id)/statistics"
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
        case .featuredCollections:
            return "/collections/featured"
        case .curatedCollections:
            return "/collections/curated"
        case let .collection(id):
            return "/collections/\(id)"
        case let .curatedCollection(id):
            return "/collections/curated\(id)"
        case let .collectionPhotos(params):
           return "/collections/\(params.id)/photos"
        case let .curatedCollectionPhotos(params):
            return "/collections/curated/\(params.id)/photos"
        case let .relatedCollections(id):
            return "/collections/\(id)/related"
        case let .updateCollection(params):
            return "/collections\(params.id)"
        case let .deleteCollection(id):
            return "/collections/\(id)"
        case let .addPhotoToCollection(params):
            return "/collections/\(params.collectionID)/add"
        case let .removePhotoFromCollection(params):
            return "/collections/\(params.collectionID)/remove"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMe,
             .userProfile,
             .userPortfolio,
             .userPhotos,
             .userLikedPhotos,
             .userCollections,
             .userStatistics,
             .photos,
             .curatedPhotos,
             .photo,
             .randomPhoto,
             .photoStatistics,
             .photoDownloadLink,
             .searchPhotos,
             .searchCollections,
             .searchUsers,
             .collections,
             .featuredCollections,
             .curatedCollections,
             .collection,
             .curatedCollection,
             .collectionPhotos,
             .curatedCollectionPhotos,
             .relatedCollections:
            return .get
        case .likePhoto,
             .createCollection,
             .addPhotoToCollection:
            return .post
        case .updateCollection,
             .updateMe:
            return .put
        case .unlikePhoto,
             .removePhotoFromCollection,
             .deleteCollection:
            return .delete
        }
    }

    var task: Task {
        let noBracketsAndLiteralBoolEncoding = URLEncoding(
            destination: .queryString,
            arrayEncoding: .noBrackets,
            boolEncoding: .literal
        )

        switch self {
        case let .updateMe(value):

            var params: [String: Any] = [:]
            params["username"] = value.username
            params["first_name"] = value.firstName
            params["last_name"] = value.lastName
            params["email"] = value.email
            params["url"] = value.url
            params["location"] = value.location
            params["bio"] = value.bio
            params["instagram_username"] = value.instagramUsername

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .userProfile(value):

            var params: [String: Any] = [:]
            params["w"] = value.width
            params["h"] = value.height

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .userPhotos(value):

            var params: [String: Any] = [:]
            params["page"] = value.page
            params["per_page"] = value.perPage
            params["order_by"] = value.orderBy
            params["stats"] = value.showStats
            params["resolution"] = value.resolution?.string
            params["quantity"] = value.quantity

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .userLikedPhotos(_, pageNumber, photosPerPage, orderBy),
             let .photos(pageNumber, photosPerPage, orderBy),
             let .curatedPhotos(pageNumber, photosPerPage, orderBy):

            var params: [String: Any] = [:]
            params["page"] = pageNumber
            params["per_page"] = photosPerPage
            params["order_by"] = orderBy

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .photo(value):

            var params: [String: Any] = [:]
            params["w"] = value.width
            params["h"] = value.height
            params["rect"] = value.rect

            return .requestParameters(
                parameters: params,
                encoding: noBracketsAndLiteralBoolEncoding)

        case let .userStatistics(_, resolution, quantity),
             let .photoStatistics(_, resolution, quantity):

            var params: [String: Any] = [:]
            params["resolution"] = resolution?.string
            params["quantity"] = quantity

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .randomPhoto(value):

            var params: [String: Any] = [:]
            params["collections"] = value.collections
            params["featured"] = value.isFeatured
            params["username"] = value.username
            params["query"] = value.query
            params["w"] = value.width
            params["h"] = value.height
            params["orientation"] = value.orientation?.string
            params["count"] = value.count

            return .requestParameters(
                parameters: params,
                encoding: noBracketsAndLiteralBoolEncoding)

        case let .userCollections(_, pageNumber, photosPerPage),
             let .collections(pageNumber, photosPerPage),
             let .featuredCollections(pageNumber, photosPerPage),
             let .curatedCollections(pageNumber, photosPerPage),
             let .collectionPhotos(_, pageNumber, photosPerPage),
             let .curatedCollectionPhotos(_, pageNumber, photosPerPage):

            var params: [String: Any] = [:]
            params["page"] = pageNumber
            params["per_page"] = photosPerPage

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .searchCollections(value),
             let .searchUsers(value):

            var params: [String: Any] = [:]
            params["query"] = value.query
            params["page"] = value.page
            params["per_page"] = value.perPage

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .searchPhotos(value):

            var params: [String: Any] = [:]
            params["query"] = value.query
            params["page"] = value.page
            params["per_page"] = value.perPage
            params["collections"] = value.collections
            params["orientation"] = value.orientation?.string

            return .requestParameters(
                parameters: params,
                encoding: noBracketsAndLiteralBoolEncoding)

        case let .createCollection(value):

            var params: [String: Any] = [:]
            params["title"] = value.title
            params["description"] = value.description
            params["private"] = value.isPrivate

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .updateCollection(value):

            var params: [String: Any] = [:]
            params["title"] = value.title
            params["description"] = value.description
            params["private"] = value.isPrivate

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        case let .addPhotoToCollection(value),
             let .removePhotoFromCollection(value):

            var params: [String: Any] = [:]
            params["photo_id"] = value.photoID

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)

        default:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        let clientID = UnsplashSettings.clientID.string
        guard let token = UserDefaults.standard.string(forKey: clientID) else {
            return ["Authorization": "Client-ID \(UnsplashSettings.clientID.string)"]
        }
        return ["Authorization": "Bearer \(token)"]
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
