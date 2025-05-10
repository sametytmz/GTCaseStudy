//
//  DiscoverViewModel.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseRemoteConfig

final class DiscoverViewModel {
    // MARK: - Properties
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let networkService: NetworkServiceProtocol
    private let cache: SessionCacheProtocol
    private var token: String? {
        return cache.get(forKey: "token")
    }
    
    // Veriler
    var firstList: [DiscoverItem] = []
    var secondList: [DiscoverItem] = []
    var twoColumnList: [DiscoverItem] = []
    
    private let firebase: IFirebaseService
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkManager.shared,
         cache: SessionCacheProtocol = SessionCache.shared,
         firebase: IFirebaseService = FirebaseService.shared) {
        self.networkService = networkService
        self.cache = cache
        self.firebase = firebase
    }
    
    // MARK: - Data Fetch
    func fetchAllData(forceRefresh: Bool = false) {
        let group = DispatchGroup()
        var errorMessage: String?
        
        // Token kontrolü
        guard let token = token else {
            onError?(NSLocalizedString("Token bulunamadı", comment: ""))
            return
        }
        let headers = ["token": token]
        
        // 1. Liste
        group.enter()
        fetchList(endpoint: .discoverFirstHorizontalList, cacheKey: "firstList", headers: headers, forceRefresh: forceRefresh) { (items: [DiscoverItem]?, error) in
            if let items = items { self.firstList = items }
            if let error = error { errorMessage = error }
            group.leave()
        }
        // 2. Liste
        group.enter()
        fetchList(endpoint: .discoverSecondHorizontalList, cacheKey: "secondList", headers: headers, forceRefresh: forceRefresh) { (items: [DiscoverItem]?, error) in
            if let items = items { self.secondList = items }
            if let error = error { errorMessage = error }
            group.leave()
        }
        // 3. Liste
        group.enter()
        fetchList(endpoint: .discoverThirthTwoColumnList, cacheKey: "twoColumnList", headers: headers, forceRefresh: forceRefresh) { (items: [DiscoverItem]?, error) in
            if let items = items { self.twoColumnList = items }
            if let error = error { errorMessage = error }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let errorMessage = errorMessage {
                self.onError?(errorMessage)
            } else {
                self.onDataUpdate?()
            }
        }
    }
    
    private func fetchList(endpoint: Endpoint, cacheKey: String, headers: [String: String], forceRefresh: Bool, completion: @escaping ([DiscoverItem]?, String?) -> Void) {
        if !forceRefresh, let cached: [DiscoverItem] = cache.get(forKey: cacheKey), !cached.isEmpty {
            completion(cached, nil)
            return
        }
        networkService.request(endpoint: endpoint.path, method: "GET", parameters: nil, headers: headers) { [weak self] (result: Result<DiscoverListResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.cache.set(object: response.list, forKey: cacheKey)
                    completion(response.list, nil)
                case .failure(let error):
                    // Offline ise cache'den dene
                    if let cached: [DiscoverItem] = self?.cache.get(forKey: cacheKey), !cached.isEmpty {
                        completion(cached, nil)
                    } else {
                        completion(nil, error.localizedDescription)
                    }
                }
            }
        }
    }

    func userTappedItem(_ item: DiscoverItem) {
        firebase.logEvent("discover_item_tap", parameters: ["item_id": item.description ?? ""])
    }

    func handleError(_ error: Error) {
        firebase.logError(error, userInfo: ["screen": "Discover"])
    }

    func fetchWelcomeText(completion: @escaping (String?) -> Void) {
        firebase.fetchRemoteConfig { success in
            let welcome = self.firebase.getRemoteConfigValue(forKey: "welcome_text")
            completion(welcome)
        }
    }
} 
