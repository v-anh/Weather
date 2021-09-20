//
//  Cache.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
    
    final class Entry {
        let value: Value
        let expirationDate: Date?

        init(value: Value, expirationDate: Date? = nil) {
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}
enum CacheType {
    case expirable(TimeInterval)
    case system
}


final class Cache<Key: Hashable, Value> {
    private let cacheType: CacheType
    private let cache = NSCache<WrappedKey, Entry>()
    private let currentDate: (() -> Date)
    init(_ type: CacheType,
         currentDate: @escaping (() -> Date) = Date.init) {
        self.cacheType = type
        self.currentDate = currentDate
    }
    func insert(_ value: Value, forKey key: Key) {
        switch self.cacheType {
        case .expirable(let expireTime):
            let date = currentDate().addingTimeInterval(expireTime)
            let entry = Entry(value: value, expirationDate: date)
            cache.setObject(entry, forKey: WrappedKey(key))
        case .system:
            cache.setObject(Entry(value: value), forKey: WrappedKey(key))
        }
    }
    
    func value(forKey key: Key) -> Value? {
        guard let entry = cache.object(forKey: WrappedKey(key)) else {
            return nil
        }
        switch self.cacheType {
        case .expirable:
            guard let expirationDate = entry.expirationDate,
                  currentDate() < expirationDate else {
                removeValue(forKey: key)
                return nil
            }
        case .system:
            return entry.value
        }
        return nil
    }
    
    func removeValue(forKey key: Key) {
        cache.removeObject(forKey: WrappedKey(key))
    }
}
