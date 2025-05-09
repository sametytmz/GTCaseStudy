//
//  AuthModels.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
} 
