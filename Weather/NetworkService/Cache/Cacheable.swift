//
//  Cacheable.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
public protocol Cacheable {
    func setObject<T:Decodable>(_ object: T, forKey key: URLRequest)
    func object<T:Decodable>(ofType type: T.Type, forKey key: URLRequest) -> T?
}

public struct URLResponseCache: Cacheable{
     
    static let `default` = {
        URLResponseCache(dateProvider: { Date.init()}, lifeTime: 100)
    }()
    
    private let cache: Cache<URLRequest,Decodable>
    
    init(dateProvider: @escaping () -> Date = Date.init, lifeTime:TimeInterval) {
        cache = Cache<URLRequest,Decodable>(.expirable(lifeTime),
                                            currentDate: dateProvider)
    }
    
    public func setObject<T:Decodable>(_ object: T, forKey key: URLRequest) {
        cache.insert(object, forKey: key)
    }
    
    public func object<T:Decodable>(ofType type: T.Type, forKey key: URLRequest) -> T? {
        cache.value(forKey: key) as? T
    }
}
