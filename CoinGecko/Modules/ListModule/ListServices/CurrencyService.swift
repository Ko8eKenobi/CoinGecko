//
//  CurrencyService.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 04.08.2025.
//

import Foundation

final class CurrencyService: CurrencyServiceProtocol {
    private let mapper: CoinMapperProtocol
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let headers: [String: String] = ["accept": "application/json", "x-cg-demo-api-key": Secrets.coinGeckoAPIKey]
    private let cacheSupportedCurrenciesKey = NSString(string: "SupportedCurrienciesCache")
    private let cacheCurrenciesLastUpdateKey = NSString(string: "CurrenciesDateCache")
    private let cacheCoinsKey = NSString(string: "CoinsLastLoadedFromApi")
    private let cacheCoinsLastUpdateKey = NSString(string: "CoinsDateCache")

    init(mapper: CoinMapperProtocol, networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.mapper = mapper
        self.networkService = networkService
        self.cacheService = cacheService
    }

    func getSupportedCurrencies() async throws -> [String] {
        if try cacheService.isRelevant(cacheKey: cacheCurrenciesLastUpdateKey, timeInterval: 60 * 60 * 24) {
            return try cacheService.load(dataKey: cacheSupportedCurrenciesKey)
        }
        do {
            let fromUrl = try await getCurrenciesFromApi()
            try cacheService.save(value: fromUrl, dataKey: cacheSupportedCurrenciesKey, dateKey: cacheCurrenciesLastUpdateKey)
            return fromUrl
        } catch {
            return try cacheService.load(dataKey: cacheSupportedCurrenciesKey)
        }
    }

    func getCoins() async throws -> [CoinModel] {
        if try cacheService.isRelevant(cacheKey: cacheCoinsLastUpdateKey, timeInterval: 60 * 60) {
            return try cacheService.load(dataKey: cacheCoinsKey)
        }
        do {
            let coins = try await getCoinsFromApi()
            try cacheService.save(value: coins, dataKey: cacheCoinsKey, dateKey: cacheCoinsLastUpdateKey)
            return coins
        } catch {
            throw error
        }
    }

    private func getCurrenciesFromApi() async throws -> [String] {
        do {
            let endPoint = GetCurrenciesEndPoint(headers: headers)
            let currencies: [String] = try await networkService.request(endPoint: endPoint)
            return currencies
        } catch {
            throw error
        }
    }

    private func getCoinsFromApi() async throws -> [CoinModel] {
        do {
            let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
            let endPoint = GetCoinsEndPoint(headers: headers, languageCode: languageCode)
            let coinsParsed: [CoinData] = try await networkService.request(endPoint: endPoint)
            return coinsParsed.map {
                mapper.map(data: $0)
            }
        } catch {
            throw error
        }
    }
}
