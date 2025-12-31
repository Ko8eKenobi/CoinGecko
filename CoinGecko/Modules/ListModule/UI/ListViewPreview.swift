//
//  ListViewPreview.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 07.08.2025.
//

#if DEBUG
    import SwiftUI

    struct ListViewControllerPreview: UIViewControllerRepresentable {

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

        func makeUIViewController(context: Context) -> UIViewController {
            let router = ListRouter(factory: CoinDetailsFactory(), alertFactory: AlertModuleFactory())
            let session = URLSession.shared
            let decoder = JSONDecoder()
            let cacher = CacheService()
            let networkService = NetworkService(session: session, decoder: decoder)
            let currencyService = CurrencyService(mapper: Mapper(), networkService: networkService, cacheService: cacher)
            let lvc = ListViewController(presenter: ListPresenter(router: router, currencyService: currencyService))

            let coins: [CoinModel] = [
                CoinModel(
                    iconUrl: URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"),
                    name: "Bitcoin",
                    currencySymbol: "btc",
                    price: "113436.0",
                    priceChange1Hour: "0.0,",
                    priceChange24Hours: "-905.83",
                    priceChange1Week: "0.0",
                    marketCapitalization: "2258 B",
                    dailyVolume: nil,
                    weekGraph: [155, 168, 140],
                    isPositivePriceChange: false
                ),
                CoinModel(
                    iconUrl: URL(string: "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628"),
                    name: "Ethereum",
                    currencySymbol: "ETH",
                    price: "3000.0",
                    priceChange1Hour: "0.0,",
                    priceChange24Hours: "-1.28",
                    priceChange1Week: "123",
                    marketCapitalization: "500 B",
                    dailyVolume: nil,
                    weekGraph: [140.0, 155.0, 168.5],
                    isPositivePriceChange: false
                ),
            ]

            lvc.showList(coins)
            return lvc
        }
    }
    struct ListViewControllerPreview_Previews: PreviewProvider {
        static var previews: some View {
            ListViewControllerPreview().edgesIgnoringSafeArea(.all).previewDisplayName("ListViewController")
        }
    }
    #Preview { ListViewControllerPreview() }
#endif
