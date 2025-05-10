//
//  SessionCacheTests.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import XCTest
@testable import GTCaseStudy

class MockSessionCache: SessionCacheProtocol {
    var storage: [String: Any] = [:]
    func set<T>(object: T, forKey key: String) where T : Codable {
        storage[key] = object
    }
    func get<T>(forKey key: String) -> T? where T : Codable {
        return storage[key] as? T
    }
    func clear() {
        storage.removeAll()
    }
}

final class SessionCacheTests: XCTestCase {
    func testCacheClearRemovesAllValues() {
        let cache = MockSessionCache()
        cache.set(object: "test", forKey: "key1")
        cache.set(object: 123, forKey: "key2")
        cache.clear()
        XCTAssertNil(cache.get(forKey: "key1") as String?)
        XCTAssertNil(cache.get(forKey: "key2") as Int?)
    }

    func testCacheOverwriteValue() {
        let cache = MockSessionCache()
        cache.set(object: "ilk", forKey: "key")
        cache.set(object: "ikinci", forKey: "key")
        XCTAssertEqual(cache.get(forKey: "key") as String?, "ikinci")
    }
} 
