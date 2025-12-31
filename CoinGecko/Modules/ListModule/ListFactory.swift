//
//  ListFactory.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 04.08.2025.
//

import Foundation
import UIKit

final class ListFactory {
    struct Context {}

    func create() -> UIViewController {
        let router = ListRouter(factory: CoinDetailsFactory(), alertFactory: AlertModuleFactory())
        let mapper = Mapper()
        let cacher = CacheService()
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let networkService = NetworkService(session: session, decoder: decoder)
        let currencyService = CurrencyService(mapper: mapper, networkService: networkService, cacheService: cacher)
        let presenter = ListPresenter(router: router, currencyService: currencyService)
        let lvc = ListViewController(presenter: presenter)

        presenter.view = lvc
        router.setRootViewController(lvc)
        return lvc
    }
}
