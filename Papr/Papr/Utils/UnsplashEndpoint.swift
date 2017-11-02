//
//  UnsplashEndpoint.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import Moya

enum Unsplash {
    case me

    // username(required), [width, height] (optional)
    case userProfile(String, Int?, Int?)

    // username(required)
    case userPortfolio(String)

    // username(required), [page, per_page, order_by](optional)
    case userPhotos(String, Int?, Int?, String?)

    // username(required), [page, per_page, order_by](optional)
    case userLikedPhotos(String, Int?, Int?, String?)

    // username(required), [page, per_page](optional)
    case userCollections(String, Int?, Int?)

    // username(required)
    case userStatistics(String)

    // [page, per_page, order_by](optional)
    case photos(Int?, Int?, String?)

    // [page, per_page, order_by](optional)
    case curatedPhotos(Int?, Int?, String?)

    // id(required)
    case photo(String)

    case randomPhoto

    // id(required)
    case photoStatistics(String)

    // id(required)
    case photoDownloadLink(String)

    // id(required)
    // case updatePhoto(String)

    // id(required)
    case likePhoto(String)
    
    // id(required)
    case unLikePhoto(String)

    // query(required) [page, per_page, collection/s id](optional)
    case searchPhotos(String, Int?, Int?, String?)

    // query(required) [page, per_page](optional)
    case searchCollections(String, Int?, Int?)

    // query(required) [page, per_page](optional)
    case searchUsers(String, Int?, Int?)

    // [page, per_page](optional)
    case collections(Int?, Int?)

    // [page, per_page](optional)
    case featuresCollections(Int?, Int?)

    // [page, per_page](optional)
    case curatedCollections(Int?, Int?)

    // id(required)
    case collection(String)
    
    // id(required)
    case curatedCollection(String)

    // id(required) [page, per_page](optional)
    case collectionPhotos(String, Int?, Int?)

    // id(required) [page, per_page](optional)
    case curatedCollectionPhotos(String, Int?, Int?)

    // id(required)
    case relatedCollections(String)

    // title(required) [description, private/public](optional)
    // case createCollection(String, String?, Bool?)

    // id(required) [title, description, private/public](optional)
    // case updateCollection(String, String?, String?, Bool?)
    
}

enum UnsplashScope {

    case pub
    case readUser
    case writeUser
    case readPhotos
    case writePhotos
    case writeLikes
    case writeFollowers
    case readCollections
    case writeCollections
    case fullScope
    
    var value: String {
        switch self {
        case .pub:
            return "public"
        case .readUser:
            return "read_user"
        case .writeUser:
            return "write_user" 
        case .readPhotos:
            return "read_photos"
        case .writePhotos:
            return "read_photos"
        case .writeLikes:
            return "write_likes"
        case .writeFollowers:
            return "write_followers"
        case .readCollections:
            return "read_collections"
        case .writeCollections:
            return "write_collections"
        case .fullScope:
            return "public read_user write_user read_photos write_photos write_likes write_followers read_collections write_collections"
        }
        
    }
}

extension Unsplash: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: String {
        switch self {
        case .me:
            return "/me"
        case .userProfile(let username, let width, let height):

            guard let w = width, let h = height else { return "/users/\(username)" }
            return "/users/\(username)?w=\(w)&h=\(h)"

        case .userPortfolio(let username):

            return "/users/\(username)/portfolio"

        case .userPhotos(let username, let pageNumber, let photosPerPage, let orderBy):

            guard let page = pageNumber, let perPage = photosPerPage, let orderBy = orderBy else { return "/users/\(username)/photos" }
            return "/users/\(username)/photos?page\(page)?per_page=\(perPage)?order_by=\(orderBy)"

        case .userLikedPhotos(let username, let pageNumber, let photosPerPage, let orderBy):

            guard let page = pageNumber, let perPage = photosPerPage, let orderBy = orderBy else { return "/users/\(username)/likes" }
            return "/users/\(username)/likes?page\(page)?per_page=\(perPage)?order_by=\(orderBy)"

        case .userCollections(let username, let pageNumber, let photosPerPage):

            guard let page = pageNumber, let perPage = photosPerPage else { return "/users/\(username)/collections" }
            return "/users/\(username)/collections?page\(page)?per_page=\(perPage)"

        case .userStatistics(let username):

            return "/users/\(username)/statistics"

        case .photos(let pageNumber, let photosPerPage, let orderBy):

            guard let page = pageNumber, let perPage = photosPerPage, let orderBy = orderBy else { return "/photos" }
            return "/photos?page\(page)?per_page=\(perPage)?order_by=\(orderBy)"

        case .curatedPhotos(let pageNumber, let photosPerPage, let orderBy):

            guard let page = pageNumber, let perPage = photosPerPage, let orderBy = orderBy else { return "/photos/curated" }
            return "/photos/curated?page\(page)?per_page=\(perPage)?order_by=\(orderBy)"

        case .photo(let id):

            return "/photos/\(id)"

        case .randomPhoto:

            return "/photos/random"
        
        case .photoStatistics(let id):

            return "/photos/\(id)/statistics" 
            
        case .photoDownloadLink(let id):
            
            return "/photos/\(id)/download"

        case .likePhoto(let id):

            return "/photos/\(id)/like"
            
        case .unLikePhoto(let id):
            
            return "/photos/\(id)/like"
            
        case .searchPhotos(let query, let pageNumber, let photosPerPage, let collections):

            guard let page = pageNumber, let perPage = photosPerPage else { return "/search/photos/\(query)" }
            guard let collections = collections else { return "/search/photos/\(query)?page\(page)?per_page=\(perPage)" }
            return "/search/photos/\(query)?page\(page)?per_page=\(perPage)?collections=\(collections)"

        case .searchCollections(let query, let pageNumber, let photosPerPage):

            guard let page = pageNumber, let perPage = photosPerPage else { return "/search/collections/\(query)" }
            return "/search/collections/\(query)?page\(page)?per_page=\(perPage)"
            
        case .searchUsers(let query, let pageNumber, let photosPerPage):
            
            guard let page = pageNumber, let perPage = photosPerPage else { return "/search/users/\(query)" }
            return "/search/users/\(query)?page\(page)?per_page=\(perPage)"
            
        case .collections(let pageNumber, let photosPerPage):
            
            guard let page = pageNumber, let perPage = photosPerPage else { return "/collections" }
            return "/collections?page\(page)?per_page=\(perPage)"
            
        case .featuresCollections(let pageNumber, let photosPerPage):
            
            guard let page = pageNumber, let perPage = photosPerPage else { return "/collections/featured" }
            return "/collections/featured?page\(page)?per_page=\(perPage)"
            
        case .curatedCollections(let pageNumber, let photosPerPage):
            
            guard let page = pageNumber, let perPage = photosPerPage else { return "/collections/curated" }
            return "/collections/curated?page\(page)?per_page=\(perPage)"
            
        case .collection(let id):
            
            return "/collections/\(id)"
            
        case .curatedCollection(let id):
            
            return "/collections/curated\(id)"

        case .collectionPhotos(let id, let pageNumber, let photosPerPage):
            
            guard let page = pageNumber, let perPage = photosPerPage else { return "/collections/\(id)/photos" }
            return "/collections/\(id)/photos?page\(page)?per_page=\(perPage)"
            
        case .curatedCollectionPhotos(let id, let pageNumber, let photosPerPage):
            
            guard let page = pageNumber, let perPage = photosPerPage else { return "/collections/curated/\(id)/photos" }
            return "/collections/curated/\(id)/photos?page\(page)?per_page=\(perPage)"
            
        case .relatedCollections(let id):
            
            return "/collections/\(id)/related"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .me, .userProfile, .userPortfolio,
             .userPhotos, .userLikedPhotos, .userCollections,
             .userStatistics, .photos, .curatedPhotos,
             .photo, .randomPhoto, .photoStatistics,
             .photoDownloadLink, .searchPhotos, .searchCollections, 
             .searchUsers, .collections, .featuresCollections,
             .curatedCollections, .collection, .curatedCollection,
             .collectionPhotos, .curatedCollectionPhotos, .relatedCollections:
            return .get
        case .likePhoto:
            return .post
        case .unLikePhoto:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
     var validate: Bool { 
        return true
    }
    
}
