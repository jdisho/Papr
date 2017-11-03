//
//  MoyaResponse+Mapper.swift
//
//  Created by Joan Disho on 22.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Mapper
import Moya

extension Response {
    
    func map<T: Mappable>(to type: T.Type) throws -> T {
        guard let jsonDict = try mapJSON() as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }
        
        do {
            return try T(map: Mapper(JSON: jsonDict))
        } catch {
            throw MoyaError.underlying(error, self)
        }
    }
    
    func map<T: Mappable>(to type: T.Type, keyPath: String?) throws -> T {
        guard let keyPath = keyPath else { return try map(to: type) }
        guard let jsonDict = try mapJSON() as? NSDictionary, 
            let objectDict = jsonDict.value(forKeyPath: keyPath) as? NSDictionary else {
                throw MoyaError.jsonMapping(self)
        }
        
        do {
            return try T(map: Mapper(JSON: objectDict))
        } catch  {
            throw MoyaError.underlying(error, self)
        }
    }
    
    func map<T: Mappable>(to type: [T].Type) throws -> [T] {
        guard let jsonArray = try mapJSON() as? [NSDictionary] else { 
            throw MoyaError.jsonMapping(self) 
        }
        
        do {
            return try jsonArray.map { try T(map: Mapper(JSON: $0)) }
        } catch {
            throw MoyaError.underlying(error, self)
        }
    }
    
    func map<T: Mappable>(to type: [T].Type, keyPath: String? = nil) throws -> [T] {
        guard let keyPath = keyPath else { return try map(to: type) }
        guard let jsonDict = try mapJSON() as? NSDictionary, 
            let objectArray = jsonDict.value(forKeyPath: keyPath) as? [NSDictionary] else {
                throw MoyaError.jsonMapping(self)
        }
        
        do {
            return try objectArray.map { try T(map: Mapper(JSON: $0)) }
        } catch {
            throw MoyaError.underlying(error, self)
        }
    }
    
}
