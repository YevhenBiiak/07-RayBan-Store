//
//  MenuListViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import UIKit

@MainActor
protocol ListView: AnyObject {
    func display(title: String)
    func hideCartBadge()
    func displayCartBadge()
    func displayError(title: String, message: String?)
}

@MainActor
protocol ListConfigurator {
    func configure(listViewController: ListViewController)
}

protocol ListPresenter {
    func viewDidLoad() async
    var numberOfRows: Int { get }
    func text(for row: Int) -> String
    func didSelect(row: Int) async
    func cartButtonTapped() async
}

class ListViewController: UITableViewController, ListView {
    
    var configurator: ListConfigurator!
    var presenter: ListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(listViewController: self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        setupNavigationBar()
        Task { await presenter.viewDidLoad() }
    }
    
    func display(title: String) {
        self.title = title
    }
    
    func hideCartBadge() {
        navigationItem.rightBarButtonItem?.image = UIImage(
            systemName: "cart", pointSize: 19, weight: .semibold, paletteColors: [.appBlack])
    }
    
    func displayCartBadge() {
        navigationItem.rightBarButtonItem?.image = UIImage(
            named: "cart.badge", pointSize: 19, weight: .semibold, paletteColors: [.appRed, .appBlack])
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        // add cart button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart", pointSize: 19, weight: .semibold, paletteColors: [.appBlack]),
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped))
    }
    
    @objc private func cartButtonTapped() {
        Task { await presenter.cartButtonTapped() }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        let text = presenter.text(for: indexPath.row)
        
        var config = cell.defaultContentConfiguration()
        config.text = text
        config.textProperties.font = UIFont.Oswald.medium.withSize(18)
        config.textProperties.color = .appBlack
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(80)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task { await presenter.didSelect(row: indexPath.row) }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
