//
//  ListEndPoints.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 13.08.2025.
//

import Foundation

struct GetCoinsEndPoint: EndPointProtocol {
    let headers: [String: String]
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    private let languageCode: String

    init(headers: [String: String], languageCode: String) {
        self.headers = headers
        self.languageCode = languageCode
        path = "coins/markets"
        method = HTTPMethod.get
        queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"), URLQueryItem(name: "include_tokens", value: "top"),
            URLQueryItem(name: "sparkline", value: "true"), URLQueryItem(name: "price_change_percentage", value: "1h,24h,7d"),
            URLQueryItem(name: "locale", value: languageCode), URLQueryItem(name: "precision", value: "2"),
        ]
    }
}

struct GetCurrenciesEndPoint: EndPointProtocol {
    let headers: [String: String]
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?

    init(headers: [String: String]) {
        self.headers = headers
        path = "simple/supported_vs_currencies"
        method = HTTPMethod.get
        queryItems = nil
    }
}
