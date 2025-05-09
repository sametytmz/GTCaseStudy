//
//  DiscoverModels.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 9.05.2025.
//

import Foundation

struct DiscoverItem: Decodable {
    let id: Int
    let title: String
    let imageUrl: String?
    let description: String?
    let price: String?
    let oldPrice: String?
    let discount: String?
    let rating: Double?
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
