//
//  SessionCache.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation

protocol SessionCacheProtocol {
    func set<T: Codable>(object: T, forKey key: String)
    func get<T: Codable>(forKey key: String) -> T?
    func clear()
}

class SessionCache: SessionCacheProtocol {
    static let shared = SessionCache()
    private init() {}
    
    private var cache: [String: Any] = [:]
    
    func set<T>(object: T, forKey key: String) {
        cache[key] = object
        if key == "token", let token = object as? String {
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    func get<T>(forKey key: String) -> T? {
        if key == "token" {
            if let token = UserDefaults.standard.string(forKey: "token") as? T {
                return token
            }
        }
        return cache[key] as? T
    }
    
    func clear() {
        cache.removeAll()
        UserDefaults.standard.removeObject(forKey: "token")
    }
} 
