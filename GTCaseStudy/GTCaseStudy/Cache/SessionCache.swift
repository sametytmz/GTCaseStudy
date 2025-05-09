//
//  SessionCache.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation

class SessionCache {
    static let shared = SessionCache()
    private init() {}
    
    private var cache: [String: Any] = [:]
    
    func set<T>(object: T, forKey key: String) {
        cache[key] = object
    }
    
    func get<T>(forKey key: String) -> T? {
        return cache[key] as? T
    }
    
    func clear() {
        cache.removeAll()
    }
} 
