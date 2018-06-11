//
//  CacheManager.swift
//  FirebaseDemo
//
//  Created by Ron Yi on 2018/6/7.
//  Copyright © 2018年 AppCoda. All rights reserved.
//

import Foundation

//建立快取配置，用來改善表格視圖的效能
enum CacheConfiguration {
    static let maxObjects = 100
    static let maxSize = 1024 * 1024 * 50
}

final class CacheManager {
    static let shared: CacheManager = CacheManager()
    private static var cache: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        cache.countLimit = CacheConfiguration.maxObjects
        cache.totalCostLimit = CacheConfiguration.maxSize
        
        return cache
    }()
    
    private init() { }
    
    func cache(object: AnyObject,key: String) {
        CacheManager.cache.setObject(object, forKey: key as NSString)
    }
    
    func getFromCache(key: String) -> AnyObject? {
        return CacheManager.cache.object(forKey: key as NSString)
    }
    
}
