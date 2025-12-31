//
//  ListCoinTableViewCell.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 06.08.2025.
//
import Kingfisher
import UIKit

final class ListCoinTableViewCell: UITableViewCell {
    func configure(coin: CoinModel) {
        name.text = coin.name
        price.text = coin.price
        currencySymbol.text = coin.currencySymbol
        priceChange24h.text = coin.priceChange24Hours
        marketCap.text = coin.marketCapitalization
        dailyVolume.text = coin.dailyVolume
        sparkLine7d.prices = coin.weekGraph
        price.textColor = getPriceColor()
        icon.kf.setImage(with: coin.iconUrl, placeholder: UIImage(systemName: "photo"))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        icon.kf.cancelDownloadTask()
        icon.image = UIImage(systemName: "photo")
        name.text = nil
        price.text = nil
        currencySymbol.text = nil
        priceChange24h.text = nil
        marketCap.text = nil
        dailyVolume.text = nil
        sparkLine7d.reset()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private let icon: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.backgroundColor = .systemBackground
        image.isOpaque = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let name: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.backgroundColor = .systemBackground
        label.isOpaque = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let currencySymbol: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        label.backgroundColor = .systemBackground
        label.isOpaque = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let price: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        label.backgroundColor = .systemBackground
        label.isOpaque = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceChange24h: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.isOpaque = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let currencyLabelsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .systemBackground
        stack.isOpaque = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let auxilaryPricesVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.backgroundColor = .systemBackground
        stack.isOpaque = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let mainHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.backgroundColor = .systemBackground
        stack.isOpaque = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let pricesHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.backgroundColor = .systemBackground
        stack.isOpaque = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let marketCap: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.isOpaque = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dailyVolume: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sparkLine7d: SparklineView = {
        let view = SparklineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setupUI() {
        mainHStack.addArrangedSubview(icon)
        currencyLabelsVStack.addArrangedSubview(currencySymbol)
        currencyLabelsVStack.addArrangedSubview(name)
        mainHStack.addArrangedSubview(currencyLabelsVStack)
        price.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        pricesHStack.addArrangedSubview(price)
        auxilaryPricesVStack.addArrangedSubview(priceChange24h)
        auxilaryPricesVStack.addArrangedSubview(marketCap)
        auxilaryPricesVStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        pricesHStack.addArrangedSubview(auxilaryPricesVStack)
        mainHStack.addArrangedSubview(pricesHStack)

        mainHStack.addArrangedSubview(sparkLine7d)

        contentView.addSubview(mainHStack)

        NSLayoutConstraint.activate([

            price.centerXAnchor.constraint(lessThanOrEqualTo: mainHStack.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 40), icon.heightAnchor.constraint(equalToConstant: 40),

            sparkLine7d.widthAnchor.constraint(equalToConstant: 70),
            sparkLine7d.heightAnchor.constraint(equalTo: icon.heightAnchor),
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
    private func getPriceColor() -> UIColor {
        let first = sparkLine7d.prices.first ?? 0
        let last = sparkLine7d.prices.last ?? 0
        return last >= first ? .green : .red
    }
}

#if DEBUG
    import SwiftUI

    struct CoinCellPreview: UIViewRepresentable {
        func updateUIView(_ uiView: UIView, context: Context) {
            //
        }

        func makeUIView(context: Context) -> UIView {
            let cell = ListCoinTableViewCell(style: .default, reuseIdentifier: "CoinCell")

            let model = CoinModel(
                iconUrl: URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"),
                name: "Bitcoin",
                currencySymbol: "btc",
                price: "113436.0",
                priceChange1Hour: "0.0,",
                priceChange24Hours: "-905.83",
                priceChange1Week: "0.0",
                marketCapitalization: "2258 B",
                dailyVolume: nil,
                weekGraph: [155, 168, 140, 124],
                isPositivePriceChange: false
            )

            cell.configure(coin: model)
            cell.frame = CGRect(x: 0, y: 0, width: 375, height: 60)
            cell.backgroundColor = .systemBackground
            cell.contentView.backgroundColor = .systemBackground
            cell.contentView.isOpaque = true
            return cell
        }
    }

    struct CoinCellPreview_Previews: PreviewProvider {
        static var previews: some View { CoinCellPreview().ignoresSafeArea(edges: .all).previewLayout(.sizeThatFits) }
    }
#endif
