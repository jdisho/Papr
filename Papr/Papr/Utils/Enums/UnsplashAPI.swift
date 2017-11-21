//
//  UnsplashAPI.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift

enum UnsplashAPI {

    case me

    // username(required), [width, height] (optional)
    case userProfile(String, Int?, Int?)

    // username(required)
    case userPortfolio(String)

    // username(required), [page, per_page, order_by](optional)
    case userPhotos(String, Int?, Int?, OrderBy?)

    // username(required), [page, per_page, order_by](optional)
    case userLikedPhotos(String, Int?, Int?, OrderBy?)

    // username(required), [page, per_page](optional)
    case userCollections(String, Int?, Int?)

    // username(required)
    case userStatistics(String)

    // [page, per_page, order_by](optional)
    case photos(Int?, Int?, OrderBy?)

    // [page, per_page, order_by](optional)
    case curatedPhotos(Int?, Int?, OrderBy?)

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

extension UnsplashAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: String {
        switch self {
        case .me:
            return "/me"
        case .userProfile(let username):
            return "/users/\(username)"
        case .userPortfolio(let username):
            return "/users/\(username)/portfolio"
        case .userPhotos(let username):
            return "/users/\(username)/photos"
        case .userLikedPhotos(let username):
            return "/users/\(username)/likes"
        case .userCollections(let username):
            return "/users/\(username)/collections"
        case .userStatistics(let username):
            return "/users/\(username)/statistics"
        case .photos:
           return "/photos"
        case .curatedPhotos:
            return "/photos/curated"
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
        case .searchPhotos:
          return "/search/photos"
        case .searchCollections:
            return "/search/collections"
        case .searchUsers:
            return "/search/users"
        case .collections:
            return "/collections"
        case .featuresCollections:
            return "/collections/featured"
        case .curatedCollections:
            return "/collections/curated"
        case .collection(let id):
            return "/collections/\(id)"
        case .curatedCollection(let id):
            return "/collections/curated\(id)"
        case .collectionPhotos(let id):
           return "/collections/\(id)/photos"
        case .curatedCollectionPhotos(let id):
            return "/collections/curated/\(id)/photos"
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
        switch self {
        case .userProfile(_, let width, let height):
            
            guard let width = width, let height = height else { 
                return .requestPlain
            }
            return .requestParameters(parameters: ["w": width, 
                                                   "h": height], 
                                      encoding: URLEncoding.default) 
        
        case .userPhotos(_, let pageNumber, let photosPerPage, let orderBy),
             .userLikedPhotos(_, let pageNumber, let photosPerPage, let orderBy),
             .photos(let pageNumber, let photosPerPage, let orderBy),
             .curatedPhotos(let pageNumber, let photosPerPage, let orderBy):
            
            guard let pageNumber = pageNumber, let photosPerPage = photosPerPage, let orderBy = orderBy else { 
                return .requestPlain
            }
            return .requestParameters(parameters: [ "page": pageNumber, 
                                                   "per_page": photosPerPage, 
                                                   "order_by": orderBy], 
                                      encoding: URLEncoding.default)
        
        case .userCollections(_, let pageNumber, let photosPerPage),
             .collections(let pageNumber, let photosPerPage),
             .featuresCollections(let pageNumber, let photosPerPage),
             .curatedCollections(let pageNumber, let photosPerPage),
             .collectionPhotos(_, let pageNumber, let photosPerPage),
             .curatedCollectionPhotos(_, let pageNumber, let photosPerPage):
            
            guard let pageNumber = pageNumber, let photosPerPage = photosPerPage else { 
                return .requestPlain
            }
            return .requestParameters(parameters: [ "page": pageNumber, 
                                                   "per_page": photosPerPage], 
                                      encoding: URLEncoding.default)
       
        case .searchCollections(let query, let pageNumber, let photosPerPage), 
             .searchUsers(let query, let pageNumber, let photosPerPage):
           
            guard let pageNumber = pageNumber, let photosPerPage = photosPerPage else { 
                return .requestParameters(parameters: ["query": query], 
                                          encoding: URLEncoding.default) 
            }
            return .requestParameters(parameters: ["page": pageNumber, 
                                                   "per_page": photosPerPage, 
                                                   "query": query], 
                                      encoding: URLEncoding.default)
       
        case .searchPhotos(let query, let pageNumber, let photosPerPage, let collections):
            
            guard let pageNumber = pageNumber, let photosPerPage = photosPerPage, let collections =  collections else { 
                return .requestParameters(parameters: ["query": query], 
                                          encoding: URLEncoding.default) 
            }
            return .requestParameters(parameters: ["page": pageNumber, 
                                                   "per_page": photosPerPage, 
                                                   "query": query, 
                                                   "collections": collections], 
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        guard let accessToken = KeychainSwift().get(OAuth2Config.clientID.string) else { 
            return ["Authorization": "Client-ID " + OAuth2Config.clientID.string] 
        }
        return ["Authorization": "Bearer " + accessToken]
    }
    
    var validate: Bool {
        return true
    } 
    
}
