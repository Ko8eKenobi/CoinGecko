//
//  ListRouter.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import Foundation
import UIKit

final class ListRouter: ListRouterProtocol {
    private weak var rootController: UIViewController?
    private let factory: CoinDetailsFactory
    private let alertFactory: AlertModuleFactory

    init(factory: CoinDetailsFactory, alertFactory: AlertModuleFactory) {
        self.factory = factory
        self.alertFactory = alertFactory
    }

    func setRootViewController(_ rootController: UIViewController) { self.rootController = rootController }

    func openCoinDetails(with coin: CoinModel) {
        let context = CoinDetailsFactory.Context(coin: coin)
        let detailVC = factory.create(context: context)
        rootController?.navigationController?.pushViewController(detailVC, animated: true)
    }

    func showError(error: Error) {
        let avc = alertFactory.create(title: "Error", message: error.localizedDescription)
        rootController?.present(avc, animated: true)
    }
}
