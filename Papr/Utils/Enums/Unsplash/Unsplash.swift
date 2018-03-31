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
        height: Int?)

    /// Get a random photo
    case randomPhoto(
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

extension Unsplash: ResourceType  {

    var baseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("FAILED: https://api.unsplash.com")
        }
        return url
    }
    
    var endpoint: String {
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

    var method: HTTPMethod {
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
        switch self {
        case let .updateMe(value):
            var params: [String: String] = [:]

            if let username = value.username {
                params["username"] = username
            }
            if let firstName = value.firstName {
                params["first_name"] = firstName
            }
            if let lastName = value.lastName {
                params["last_name"] = lastName
            }
            if let email = value.email {
                params["email"] = email
            }
            if let url = value.url {
                params["url"] = url
            }
            if let location = value.location {
                params["location"] = location
            }
            if let bio = value.bio {
                params["bio"] = bio
            }
            if let instagramUsername = value.instagramUsername {
                params["instagram_username"] = instagramUsername
            }

            return .requestWithParameters(params)

        case let .userProfile(value):
            var params: [String: String] = [:]

            if let width = value.width {
                params["w"] = "\(width)"

            }
            if let height = value.width {
                params["h"] = "\(height)"
            }

            return .requestWithParameters(params)

        case let .userPhotos(value):
            var params: [String: String] = [:]

            if let pageNumber = value.page {
                params["page"] = "\(pageNumber)"
            }
            if let photosPerPage = value.perPage {
                params["per_page"] = "\(photosPerPage)"
            }
            if let orderBy = value.orderBy {
                params["order_by"] = "\(orderBy)"
            }
            if let showStats = value.showStats {
                 params["stats"] = showStats.description
            }
            if let resolution = value.resolution {
                params["resolution"] = resolution.string
            }
            if let quantity = value.quantity {
                 params["quantity"] = "\(quantity)"
            }

            return .requestWithParameters(params)

        case let .userLikedPhotos(_, pageNumber, photosPerPage, orderBy),
             let .photos(pageNumber, photosPerPage, orderBy),
             let .curatedPhotos(pageNumber, photosPerPage, orderBy):

            var params: [String: String] = [:]

            if let pageNumber = pageNumber {
                params["page"] = "\(pageNumber)"
            }
            if let photosPerPage = photosPerPage {
                params["per_page"] = "\(photosPerPage)"
            }
            if let orderBy = orderBy {
                params["order_by"] = "\(orderBy)"
            }

            return .requestWithParameters(params)

        case let .photo(value):
            var params: [String: String] = [:]

            if let width = value.width {
                params["width"] = "\(width)"
            }
            if let height = value.height {
                params["height"] = "\(height)"
            }

            return .requestWithParameters(params)

        case let .userStatistics(_, resolution, quantity),
             let .photoStatistics(_, resolution, quantity):

            var params: [String: String] = [:]

            if let resolution = resolution {
                params["resolution"] = resolution.string
            }

            if let quantity = quantity {
                params["quantity"] = "\(quantity)"
            }

            return .requestWithParameters(params)

        case let .randomPhoto(value):
            var params: [String: String] = [:]

            if let isFeatured = value.isFeatured {
                params["featured"] = isFeatured.description
            }
            if let username = value.username {
                params["username"] = username
            }
            if let query = value.query {
                params["query"] = query
            }
            if let width = value.width {
                params["w"] = "\(width)"
            }
            if let height = value.height {
                params["h"] = "\(height)"
            }
            if let orientation = value.orientation {
                params["orientation"] = orientation.string
            }
            if let count = value.count {
                params["count"] = "\(count)"
            }

            return .requestWithParameters(params)

        case let .userCollections(_, pageNumber, photosPerPage),
             let .collections(pageNumber, photosPerPage),
             let .featuredCollections(pageNumber, photosPerPage),
             let .curatedCollections(pageNumber, photosPerPage),
             let .collectionPhotos(_, pageNumber, photosPerPage),
             let .curatedCollectionPhotos(_, pageNumber, photosPerPage):

            var params: [String: String] = [:]

            if let pageNumber = pageNumber {
                 params["page"] = "\(pageNumber)"
            }
            if let photosPerPage = photosPerPage {
                params["per_page"] = "\(photosPerPage)"
            }

            return .requestWithParameters(params)

        case let .searchCollections(value),
             let .searchUsers(value):

            var params: [String: String] = [:]
            params["query"] = value.query

            if let pageNumber = value.page {
                params["page"] = "\(pageNumber)"
            }

            if let photosPerPage = value.perPage {
                params["per_page"] = "\(photosPerPage)"
            }

            return .requestWithParameters(params)

        case let .searchPhotos(value):
            var params: [String: String] = [:]
            params["query"] = value.query

            if let pageNumber = value.page {
                params["page"] = "\(pageNumber)"
            }
            if let photosPerPage = value.perPage {
                params["per_page"] = "\(photosPerPage)"
            }
            if let orientation = value.orientation {
                params["orientation"] = orientation.string
            }

            return .requestWithParameters(params)

        case let .createCollection(value):

            var params: [String: String] = [:]
            params["title"] = value.title

            if let description = value.description {
                params["description"] = description
            }
            if let isPrivate = value.isPrivate {
                params["description"] = isPrivate.description
            }

            return .requestWithParameters(params)

        case let .updateCollection(value):
            var params: [String: String] = [:]

            if let title = value.title {
                params["title"] = title
            }
            if let description = value.description {
                params["description"] = description
            }
            if let isPrivate = value.isPrivate {
                params["description"] = isPrivate.description
            }

            return .requestWithParameters(params)

        case let .addPhotoToCollection(value),
             let .removePhotoFromCollection(value):

            var params: [String: String] = [:]
            params["photo_id"] = value.photoID

            return .requestWithParameters(params)

        default:
            return .requestWithParameters([:])
        }
    }

    var headers: [String : String] {
        let clientID = UnsplashSettings.clientID.string
        guard let token = UserDefaults.standard.string(forKey: clientID) else {
            return ["Authorization": "Client-ID \(UnsplashSettings.clientID.string)"]
        }
        return ["Authorization": "Bearer \(token)"]
    }
}
