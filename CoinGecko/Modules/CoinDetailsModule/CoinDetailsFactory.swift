//
//  CoinDetailsFactory.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import Foundation
import UIKit

final class CoinDetailsFactory {
    struct Context {
        let coin: CoinModel
    }

    func create(context: Context) -> UIViewController {
        CoinDetailsViewController(coin: context.coin)
    }
}
