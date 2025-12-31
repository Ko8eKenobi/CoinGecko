//
//  Mappers.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 12.08.2025.
//

import Foundation

struct Mapper: CoinMapperProtocol {
    func map(data: CoinData) -> CoinModel {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .decimal
        priceFormatter.minimumFractionDigits = 0
        priceFormatter.maximumFractionDigits = 2

        let currencySymbol = data.currencySymbol.uppercased()
        let price = priceFormatter.string(from: NSNumber(value: data.price)) ?? ""
        let priceChange1Hour = priceFormatter.string(from: NSNumber(value: data.priceChange1Hour ?? 0)) ?? ""
        let priceChange24Hours = priceFormatter.string(from: NSNumber(value: data.priceChange24Hours ?? 0)) ?? ""
        let priceChange1Week = data.priceChange1Week.flatMap {
            priceFormatter.string(from: NSNumber(value: $0))
        }
        let formattedCap = data.marketCapitalization / 1_000_000_000
        let marketCapitalization = (priceFormatter.string(from: NSNumber(value: formattedCap)) ?? "") + " B"
        let dailyVolume = priceFormatter.string(from: NSNumber(value: data.dailyVolume ?? 0))

        //make function of calculating factorial

        return CoinModel(
            iconUrl: URL(string: data.image),
            name: data.name,
            currencySymbol: currencySymbol,
            price: price,
            priceChange1Hour: priceChange1Hour,
            priceChange24Hours: priceChange24Hours,
            priceChange1Week: priceChange1Week,
            marketCapitalization: marketCapitalization,
            dailyVolume: dailyVolume,
            weekGraph: data.sparkLineIn7d.price,
            isPositivePriceChange: false
        )
    }
}
