//
//  NetworkManager.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: String,
                              method: String,
                              parameters: [String: Any]?,
                              headers: [String: String]?,
                              completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: NetworkServiceProtocol {
    static let shared = NetworkManager()
    private let baseURL = "https://garanti-teknoloji-mobile-auth-casestudy.vercel.app"
    private init() {}
    
    func request<T: Decodable>(endpoint: String,
                              method: String,
                              parameters: [String: Any]? = nil,
                              headers: [String: String]? = nil,
                              completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("API Response JSON:\n\(prettyString)")
            } else {
                print("API Response (raw): \(String(data: data, encoding: .utf8) ?? "<binary>")")
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
} 
