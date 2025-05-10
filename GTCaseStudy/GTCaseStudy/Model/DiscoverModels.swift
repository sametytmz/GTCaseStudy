//
//  DiscoverModels.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation

struct Price: Decodable {
    let value: Double
    let currency: String
}

struct DiscoverItem: Decodable {
    let discount: String?
    let ratePercentage: Int?
    let imageUrl: String?
    let description: String?
    let price: Price?
    let oldPrice: Price?
}

struct DiscoverListResponse: Decodable {
    let list: [DiscoverItem]
}

struct DiscoverFirstHorizontalListResponse: Decodable {
    let items: [DiscoverItem]
}

struct DiscoverSecondHorizontalListResponse: Decodable {
    let items: [DiscoverItem]
}

struct DiscoverThirthTwoColumnListResponse: Decodable {
    let items: [DiscoverItem]
} 
