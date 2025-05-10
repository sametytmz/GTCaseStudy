//
//  DiscoverViewModelTests.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import XCTest
@testable import GTCaseStudy

func makeDiscoverListResponseFromFile(named fileName: String) -> DiscoverListResponse {
    let bundle = Bundle(for: DiscoverViewModelTests.self)
    let url = bundle.url(forResource: fileName, withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(DiscoverListResponse.self, from: data)
}

class MockDiscoverNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var response: DiscoverListResponse?
    func request<T>(endpoint: String, method: String, parameters: [String : Any]?, headers: [String : String]?, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else if let response = response as? T {
            completion(.success(response))
        }
    }
}

class MockDiscoverCache: SessionCacheProtocol {
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

final class DiscoverViewModelTests: XCTestCase {
    func testFetchAllDataSuccess() {
        let mockNetwork = MockDiscoverNetworkService()
        let mockCache = MockDiscoverCache()
        let mockResponse = makeDiscoverListResponseFromFile(named: "DiscoverMock")
        mockNetwork.response = mockResponse
        mockCache.set(object: "token", forKey: "token")
        let viewModel = DiscoverViewModel(networkService: mockNetwork, cache: mockCache)
        let exp = expectation(description: "onDataUpdate çağrılmalı")
        viewModel.onDataUpdate = {
            XCTAssertEqual(viewModel.firstList.count, 2)
            XCTAssertEqual(viewModel.firstList.first?.description, "Kitap 1")
            XCTAssertEqual(viewModel.secondList.count, 2)
            XCTAssertEqual(viewModel.twoColumnList.count, 2)
            exp.fulfill()
        }
        viewModel.onError = { _ in XCTFail() }
        viewModel.fetchAllData(forceRefresh: true)
        waitForExpectations(timeout: 2)
    }

    func testFetchAllDataError() {
        let mockNetwork = MockDiscoverNetworkService()
        let mockCache = MockDiscoverCache()
        mockNetwork.shouldReturnError = true
        mockCache.set(object: "token", forKey: "token")
        let viewModel = DiscoverViewModel(networkService: mockNetwork, cache: mockCache)
        let exp = expectation(description: "onError çağrılmalı")
        viewModel.onDataUpdate = { XCTFail() }
        viewModel.onError = { error in
            XCTAssertEqual(error, "Mock error")
            exp.fulfill()
        }
        viewModel.fetchAllData(forceRefresh: true)
        waitForExpectations(timeout: 2)
    }

    func testFetchAllDataUsesCache() {
        let mockNetwork = MockDiscoverNetworkService()
        let mockCache = MockDiscoverCache()
        let mockResponse = makeDiscoverListResponseFromFile(named: "DiscoverMock")
        mockCache.set(object: mockResponse.list, forKey: "firstList")
        mockCache.set(object: mockResponse.list, forKey: "secondList")
        mockCache.set(object: mockResponse.list, forKey: "twoColumnList")
        mockCache.set(object: "token", forKey: "token")
        let viewModel = DiscoverViewModel(networkService: mockNetwork, cache: mockCache)
        let exp = expectation(description: "onDataUpdate cache ile çağrılmalı")
        viewModel.onDataUpdate = {
            XCTAssertEqual(viewModel.firstList.first?.description, "Kitap 1")
            exp.fulfill()
        }
        viewModel.onError = { _ in XCTFail() }
        viewModel.fetchAllData(forceRefresh: false)
        waitForExpectations(timeout: 2)
    }

    func testFetchAllDataWithoutToken() {
        let mockNetwork = MockDiscoverNetworkService()
        let mockCache = MockDiscoverCache()
        let viewModel = DiscoverViewModel(networkService: mockNetwork, cache: mockCache)
        let exp = expectation(description: "onError token yoksa çağrılmalı")
        viewModel.onDataUpdate = { XCTFail() }
        viewModel.onError = { error in
            XCTAssertTrue(error.contains("Token"))
            exp.fulfill()
        }
        viewModel.fetchAllData(forceRefresh: true)
        waitForExpectations(timeout: 2)
    }

    func testFetchAllDataPartialErrorTriggersOnError() {
        class PartialErrorNetwork: NetworkServiceProtocol {
            var callCount = 0
            func request<T>(endpoint: String, method: String, parameters: [String : Any]?, headers: [String : String]?, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
                callCount += 1
                if callCount == 1 {
                    // İlk çağrı başarılı
                    let mockResponse = makeDiscoverListResponseFromFile(named: "DiscoverMock")
                    completion(.success(mockResponse as! T))
                } else {
                    // Diğer çağrılar hata
                    completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Partial error"])))
                }
            }
        }
        let mockNetwork = PartialErrorNetwork()
        let mockCache = MockDiscoverCache()
        mockCache.set(object: "token", forKey: "token")
        let viewModel = DiscoverViewModel(networkService: mockNetwork, cache: mockCache)
        let exp = expectation(description: "onError kısmi hata durumunda çağrılmalı")
        viewModel.onDataUpdate = { XCTFail() }
        viewModel.onError = { error in
            XCTAssertEqual(error, "Partial error")
            exp.fulfill()
        }
        viewModel.fetchAllData(forceRefresh: true)
        waitForExpectations(timeout: 2)
    }
} 
