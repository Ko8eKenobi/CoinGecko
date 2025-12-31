//
//  ListModels.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import Foundation

// MARK: Error response model
struct ErrorResponse: Decodable { let error: String }

struct SparkLineIn7d: Decodable { let price: [Double] }

// MARK: Data layer structure
struct CoinData: Decodable {
    let image: String
    let name: String
    let currencySymbol: String
    let price: Double
    let priceChange1Hour: Double?
    let priceChange24Hours: Double?
    let priceChange1Week: Double?
    let dailyVolume: Double?
    let marketCapitalization: Double
    let sparkLineIn7d: SparkLineIn7d

    enum CodingKeys: String, CodingKey {
        case image
        case name
        case currencySymbol = "symbol"
        case price = "current_price"
        case dailyVolume = "total_volume"
        case marketCapitalization = "market_cap"
        case priceChange1Hour = "price_change_percentage_1h_in_currency"
        case priceChange24Hours = "price_change_percentage_24h_in_currency"
        case priceChange1Week = "price_change_percentage_7d_in_currency"
        case sparkLineIn7d = "sparkline_in_7d"
    }
}

// MARK: Domain structure.
struct CoinModel: Codable {
    let iconUrl: URL?
    let name: String
    let currencySymbol: String
    let price: String
    let priceChange1Hour: String
    let priceChange24Hours: String
    let priceChange1Week: String?
    let marketCapitalization: String
    let dailyVolume: String?
    let weekGraph: [Double]
    let isPositivePriceChange: Bool
}
