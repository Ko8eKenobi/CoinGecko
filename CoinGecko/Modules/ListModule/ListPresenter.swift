//
//  ListPresenter.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import Foundation

final class ListPresenter: ListPresenterProtocol {

    weak var view: ListViewProtocol?

    private let router: ListRouterProtocol
    private let currencyService: CurrencyServiceProtocol

    var coins: [CoinModel] = []
    var currencies: [String] = []

    init(router: ListRouterProtocol, currencyService: CurrencyServiceProtocol) {
        self.router = router
        self.currencyService = currencyService
    }

    func viewLoaded() {
        Task { [weak self] in
            guard let self else { return }
            await loadData()
        }
    }

    func loadData() async {
        await MainActor.run {
            view?.showLoading(true)
        }
        defer {
            Task {
                @MainActor in
                self.view?.showLoading(false)
            }
        }

        do {
            async let getCurrencies = currencyService.getSupportedCurrencies()
            async let getCoins = currencyService.getCoins()

            let (currencies, coins) = try await (getCurrencies, getCoins)
            self.coins = coins
            self.currencies = currencies
            await MainActor.run {
                self.view?.showList(self.coins)
            }
        } catch {
            await MainActor.run {
                self.showError(error)
            }
        }
    }

    func didSelectCoin(index: Int) {
        let coinToShow = coins[index]
        router.openCoinDetails(with: coinToShow)
    }

    func showError(_ error: Error) {
        router.showError(error: error)
    }
}
