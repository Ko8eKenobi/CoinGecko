//
//  ListViewController.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import UIKit

// MARK: UIViewController
final class ListViewController: UIViewController {
    private let presenter: ListPresenterProtocol
    private var coins: [CoinModel] = []

    init(presenter: ListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        presenter.viewLoaded()
    }

    private var coinTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.isOpaque = true
        return table
    }()

    private var isLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
}

// MARK: Module
extension ListViewController: ListViewProtocol {

    func showList(_ coins: [CoinModel]) {
        self.coins = coins
        coinTable.reloadData()
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            isLoadingIndicator.startAnimating()
        } else {
            isLoadingIndicator.stopAnimating()
        }
    }
}

// MARK: TableView
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    // Cells quantity
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { coins.count }

    // Cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? ListCoinTableViewCell
        else { return UITableViewCell() }
        let coin = coins[indexPath.row]
        cell.configure(coin: coin)
        cell.backgroundColor = .systemBackground
        cell.contentView.backgroundColor = .systemBackground
        cell.contentView.isOpaque = true
        return cell
    }

    // Cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCoin(index: indexPath.row)
    }
}

// MARK: Private extension to store private functions
private extension ListViewController {
    func commonInit() {
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        setupCoinTable()
    }

    func setupSubviews() {
        view.addSubview(coinTable)
        view.addSubview(isLoadingIndicator)
    }

    func setupConstraints() {
        isLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            isLoadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isLoadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func setupCoinTable() {
        coinTable.dataSource = self
        coinTable.delegate = self

        coinTable.register(ListCoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")

        coinTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            coinTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            coinTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            coinTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
