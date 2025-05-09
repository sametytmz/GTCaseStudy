//
//  Endpoint.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation

enum Endpoint {
    case login
    case discoverFirstHorizontalList
    case discoverSecondHorizontalList
    case discoverThirthTwoColumnList
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .discoverFirstHorizontalList:
            return "/discoverFirstHorizontalList"
        case .discoverSecondHorizontalList:
            return "/discoverSecondHorizontalList"
        case .discoverThirthTwoColumnList:
            return "/discoverThirthTwoColumnList"
        }
    }
} 
