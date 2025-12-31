//
//  CoinDetailsViewController.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import UIKit

final class CoinDetailsViewController: UIViewController {

    private let coinDetailsView: CoinDetailView

    init(coin: CoinModel) {
        coinDetailsView = CoinDetailView(model: coin)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = coinDetailsView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = .systemBackground

        coinDetailsView.animatedContainer.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)

        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.1,
            options: .curveEaseInOut
        ) {
            self.coinDetailsView.animatedContainer.transform = .identity
        }
    }
}
