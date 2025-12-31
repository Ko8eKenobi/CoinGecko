//
//  ListProtocols.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import Foundation

protocol ListViewProtocol: AnyObject {
    func showList(_ coins: [CoinModel])
    func showLoading(_ isLoading: Bool)
}

protocol ListPresenterProtocol {
    func viewLoaded()
    func didSelectCoin(index: Int)
}

protocol ListRouterProtocol {
    func openCoinDetails(with coin: CoinModel)
    func showError(error: Error)
}

protocol CurrencyServiceProtocol {
    func getSupportedCurrencies() async throws -> [String]
    func getCoins() async throws -> [CoinModel]
}

protocol CoinMapperProtocol {
    func map(data: CoinData) -> CoinModel
}

protocol CurrenciesMapperProtocol {
    func map(data: String) -> String
}
