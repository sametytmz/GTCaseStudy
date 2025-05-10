//
//  LoginViewModel.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation
import UIKit
import FirebaseAnalytics
import FirebaseCrashlytics

final class LoginViewModel {
    // MARK: - Properties
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    private let networkService: NetworkServiceProtocol
    private let cache: SessionCacheProtocol
    private let firebase: IFirebaseService
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkManager.shared,
         cache: SessionCacheProtocol = SessionCache.shared,
         firebase: IFirebaseService = FirebaseService.shared) {
        self.networkService = networkService
        self.cache = cache
        self.firebase = firebase
    }
    
    // MARK: - Login
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        let params: [String: Any] = [
            "email": request.email,
            "password": request.password
        ]
        networkService.request(endpoint: Endpoint.login.path,
                              method: "POST",
                              parameters: params,
                              headers: nil) { [weak self] (result: Result<LoginResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.cache.set(object: response.token, forKey: "token")
                    self?.onLoginSuccess?()
                    self?.firebase.logEvent("login_success", parameters: ["method": "email"])
                case .failure(let error):
                    self?.onLoginError?(error.localizedDescription)
                    self?.handleError(error)
                }
            }
        }
    }
    
    // MARK: - Token
    func getToken() -> String? {
        return cache.get(forKey: "token")
    }
    
    func handleError(_ error: Error) {
        firebase.logError(error, userInfo: ["screen": "Login"])
    }
} 
