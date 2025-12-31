//
//  CoinDetailView.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 09.08.2025.
//

import UIKit

final class CoinDetailView: UIView {
    private enum Const {
        static let spacingSm: CGFloat = 16
        static let shadowOffset = CGSize(width: 5, height: 5)
        static let shadowColor = UIColor.black.cgColor
        static let shadowOpacity: Float = 0.2
        static let metricFontSize: CGFloat = 25
        static let bigShadowRadius: CGFloat = 30
        static let bigCornerRadius: CGFloat = 30
        static let midCornerRadius: CGFloat = 15
        static let midBorderWidth: CGFloat = 1
        static let borderColor: CGColor = UIColor.black.cgColor
    }

    private let model: CoinModel
    private let contentView = UIView()

    var animatedContainer: UIView {
        contentView
    }

    init(model: CoinModel) {
        self.model = model
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setupLayout()
        configure(with: model)
    }

    private func setupLayout() {
        self.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false

        setupSpacers()
        setupHeader()
        setupMetrics()
        setupContent()
        setupViewConstraints()
    }

    private func setupSpacers() {
        topSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        topSpacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        bottomSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        bottomSpacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }

    private func setupHeader() {
        headerShadowContainer.translatesAutoresizingMaskIntoConstraints = false
        headerShadowContainer.layer.shadowOffset = Const.shadowOffset
        headerShadowContainer.layer.shadowColor = Const.shadowColor
        headerShadowContainer.layer.shadowOpacity = Const.shadowOpacity

        mainInfoVStack.addArrangedSubview(nameLabel)
        mainInfoVStack.addArrangedSubview(currencySymbolLabel)

        headerHStack.addArrangedSubview(coinImage)
        headerHStack.addArrangedSubview(mainInfoVStack)

        headerShadowContainer.addSubview(headerHStack)
    }

    private func setupMetrics() {
        let metrics = [
            "Price": model.price,
            "Price change (1 hour):": model.priceChange1Hour,
            "Price change (1 day):": model.priceChange24Hours,
            "Price change (1 week):": model.priceChange1Week,
        ]

        metrics.forEach {
            dataVStack.addArrangedSubview(makeCoinMetric(name: $0.key, value: $0.value ?? ""))
        }
    }
    private func setupContent() {
        addSubview(contentView)
        sparklineShadowView.addSubview(sparkLine)

        mainStack.addArrangedSubview(headerShadowContainer)
        mainStack.addArrangedSubview(topSpacer)
        mainStack.addArrangedSubview(dataVStack)
        mainStack.addArrangedSubview(bottomSpacer)
        mainStack.addArrangedSubview(sparklineShadowView)

        contentView.addSubview(mainStack)
    }

    private func setupViewConstraints() {
        NSLayoutConstraint.activate([
            topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor),

            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

            headerHStack.leadingAnchor.constraint(equalTo: headerShadowContainer.leadingAnchor),
            headerHStack.trailingAnchor.constraint(equalTo: headerShadowContainer.trailingAnchor),
            headerHStack.topAnchor.constraint(equalTo: headerShadowContainer.topAnchor),
            headerHStack.bottomAnchor.constraint(equalTo: headerShadowContainer.bottomAnchor),

            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            sparkLine.leadingAnchor.constraint(equalTo: sparklineShadowView.leadingAnchor),
            sparkLine.trailingAnchor.constraint(equalTo: sparklineShadowView.trailingAnchor),
            sparkLine.topAnchor.constraint(equalTo: sparklineShadowView.topAnchor),
            sparkLine.bottomAnchor.constraint(equalTo: sparklineShadowView.bottomAnchor),

            sparklineShadowView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    private func configure(with model: CoinModel) {
        self.coinImage.kf.setImage(with: model.iconUrl)
        nameLabel.text = model.name
        currencySymbolLabel.text = model.currencySymbol
        sparkLine.prices = model.weekGraph
    }

    private func makeCoinMetric(name: String, value: String) -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .boldSystemFont(ofSize: Const.metricFontSize)
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textAlignment = .right
        valueLabel.font = .systemFont(ofSize: Const.metricFontSize, weight: .heavy, width: .standard)
        let stack = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        return stack
    }

    private let topSpacer = UIView()

    private let bottomSpacer = UIView()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Const.spacingSm
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(
            top: Const.spacingSm,
            left: Const.spacingSm,
            bottom: Const.spacingSm,
            right: Const.spacingSm
        )
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    private let headerShadowContainer = UIView()

    private let headerHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = Const.spacingSm
        stack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let dataVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Const.spacingSm
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let coinImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        image.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let mainInfoVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 35)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let currencySymbolLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 30)

        return label
    }()

    private let sparkLine: SparklineView = {
        let view = SparklineView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.borderColor = Const.borderColor
        view.layer.borderWidth = Const.midBorderWidth
        view.layer.cornerRadius = Const.bigCornerRadius
        view.layer.masksToBounds = true

        return view
    }()

    var sparklineShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.shadowColor = Const.shadowColor
        view.layer.shadowOpacity = Const.shadowOpacity
        view.layer.shadowOffset = Const.shadowOffset
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Const.bigCornerRadius
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        if headerShadowContainer.bounds != .zero {
            headerShadowContainer.layer.shadowPath =
                UIBezierPath(
                    roundedRect: headerShadowContainer.bounds,
                    cornerRadius: Const.midCornerRadius
                ).cgPath
        }

        if sparklineShadowView.bounds != .zero {
            print("setting shadow path")
            sparklineShadowView.layer.shadowPath =
                UIBezierPath(
                    roundedRect: sparklineShadowView.bounds,
                    cornerRadius: Const.bigCornerRadius
                ).cgPath
        }
    }
}

#if DEBUG
    import SwiftUI

    struct CoinDetailsPreview: UIViewRepresentable {

        func makeUIView(context: Context) -> CoinDetailView {
            let model = CoinModel(
                iconUrl: URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"),
                name: "Bitcoin 123 asdlufh eiuelhaf",
                currencySymbol: "btc",
                price: "113436.0",
                priceChange1Hour: "0.0",
                priceChange24Hours: "-905.83",
                priceChange1Week: "No data",
                marketCapitalization: "2258403459157",
                dailyVolume: nil,
                weekGraph: [155, 168, 140, 124, 150, 153, 145],
                isPositivePriceChange: false
            )
            let view = CoinDetailView(model: model)
            return view
        }

        func updateUIView(_ uiView: CoinDetailView, context: Context) {
            // Update.
        }
    }

    struct CoinDetailsPreview_Previews: PreviewProvider {
        static var previews: some View { CoinDetailsPreview().edgesIgnoringSafeArea(.all).previewDisplayName("CoinDetailView") }
    }
#endif
