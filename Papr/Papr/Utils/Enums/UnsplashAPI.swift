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
    case userProfile(username: String, width: Int?, height: Int?)
    case userPortfolio(username: String)
    case userPhotos(username: String, page: Int?, perPage: Int?, orderBy: OrderBy?)
    case userLikedPhotos(username: String, page: Int?, perPage: Int?, orderBy: OrderBy?)
    case userCollections(username:String, page: Int?, perPage: Int?)
    case userStatistics(username: String)
    case photos(page: Int?, perPage: Int?, orderBy: OrderBy?)
    case curatedPhotos(page: Int?, perPage: Int?, orderBy: OrderBy?)
    case photo(id: String)
    case randomPhoto
    case photoStatistics(id: String)
    case photoDownloadLink(id: String)
    case likePhoto(id: String)
    case unLikePhoto(id: String)
    case searchPhotos(query: String, page: Int?, perPage: Int?, collectionID: String?)
    case searchCollections(query: String, page: Int?, perPage: Int?)
    case searchUsers(query: String, page: Int?, perPage: Int?)
    case collections(page: Int?, perPage: Int?)
    case featuresCollections(page: Int?, perPage: Int?)
    case curatedCollections(page: Int?, perPage: Int?)
    case collection(id: String)
    case curatedCollection(id: String)
    case collectionPhotos(id: String, page: Int?, perPage: Int?)
    case curatedCollectionPhotos(id: String, page: Int?, perPage: Int?)
    case relatedCollections(id: String)

    // MARK: - TODO: Support these cases

    // id(required)
    // case updatePhoto(String)

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
        guard let accessToken = UnsplashAuthManager.sharedAuthManager.accessToken else { 
            return ["Authorization": "Client-ID " + OAuth2Config.clientID.string] 
        }
        return ["Authorization": "Bearer " + accessToken]
    }
    
    var validate: Bool {
        return true
    } 
    
}
