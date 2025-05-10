//
//  LoginViewModelTests.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import XCTest
@testable import GTCaseStudy

// Mock servisler
class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var loginResponse: LoginResponse?
    func request<T>(endpoint: String, method: String, parameters: [String : Any]?, headers: [String : String]?, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else if let response = loginResponse as? T {
            completion(.success(response))
        }
    }
}

class MockLoginCache: SessionCacheProtocol {
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

class MockLoginCoordinator: LoginCoordinator {
    var didRouteToMainTabBar = false
    func showMainTabBar() {
        didRouteToMainTabBar = true
    }
}

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockNetwork: MockNetworkService!
    var mockCache: MockLoginCache!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkService()
        mockCache = MockLoginCache()
        viewModel = LoginViewModel(networkService: mockNetwork, cache: mockCache)
    }

    func testLoginSuccess() {
        let expectation = self.expectation(description: "Login success closure çağrılmalı")
        let token = "test_token"
        mockNetwork.loginResponse = LoginResponse(token: token)
        viewModel.onLoginSuccess = {
            // Token cache'e yazıldı mı?
            let cached: String? = self.mockCache.get(forKey: "token")
            XCTAssertEqual(cached, token)
            expectation.fulfill()
        }
        viewModel.onLoginError = { _ in
            XCTFail("Başarılı login'de hata closure'ı çağrılmamalı")
        }
        viewModel.login(email: "test@test.com", password: "123456")
        waitForExpectations(timeout: 1)
    }

    func testLoginFailure() {
        let expectation = self.expectation(description: "Login error closure çağrılmalı")
        mockNetwork.shouldReturnError = true
        viewModel.onLoginSuccess = {
            XCTFail("Başarısız login'de success closure'ı çağrılmamalı")
        }
        viewModel.onLoginError = { error in
            XCTAssertEqual(error, "Mock error")
            expectation.fulfill()
        }
        viewModel.login(email: "test@test.com", password: "123456")
        waitForExpectations(timeout: 1)
    }

    func testGetTokenReturnsCachedToken() {
        let token = "cached_token"
        mockCache.set(object: token, forKey: "token")
        XCTAssertEqual(viewModel.getToken(), token)
    }
}

final class LoginViewControllerRouteTests: XCTestCase {
    func testLoginSuccessRoutesToMainTabBar() {
        // Given
        let viewModel = LoginViewModel(networkService: MockNetworkService(), cache: MockLoginCache())
        let mockCoordinator = MockLoginCoordinator()
        let loginVC = LoginViewController(viewModel: viewModel)
        loginVC.coordinator = mockCoordinator
        // When
        loginVC.viewDidLoad()
        viewModel.onLoginSuccess?()
        // Then
        XCTAssertTrue(mockCoordinator.didRouteToMainTabBar, "Login success sonrası route işlemi coordinator üzerinden yapılmalı")
    }
} 
