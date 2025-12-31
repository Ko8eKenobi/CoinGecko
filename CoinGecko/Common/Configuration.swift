//
//  Configuration.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 31.12.2025.
//
import Foundation

enum Secrets {
    static var coinGeckoAPIKey: String {
        guard
            let key = Bundle.main.object(
                forInfoDictionaryKey: "COINGECKO_API_KEY"
            ) as? String
        else {
            fatalError("COINGECKO_API_KEY not found")
        }
        return key
    }
}
