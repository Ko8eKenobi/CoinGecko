//
//  AlertModuleFactory.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 06.08.2025.
//

import UIKit

final class AlertModuleFactory {
    func create(
        title: String,
        message: String
    ) -> UIViewController {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default)
        alertViewController.addAction(action)
        return alertViewController
    }
}
