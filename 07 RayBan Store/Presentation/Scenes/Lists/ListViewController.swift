//
//  MenuListViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import UIKit

protocol ListView: AnyObject {
    func display(title: String)
}

protocol ListConfigurator {
    func configure(listViewController: ListViewController)
}

protocol ListPresenter {
    func viewDidLoad()
    var numberOfItems: Int { get }
    func getTitle(forRow row: Int) -> String
    func didSelect(row: Int)
    func cartButtonTapped()
}

class ListViewController: UIViewController, ListView {
    
    var configurator: ListConfigurator!
    var presenter: ListPresenter!
    var rootView: ListRootView!
    
    override func loadView() {
        configurator.configure(listViewController: self)
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectinView()
        presenter.viewDidLoad()
    }
    
    func display(title: String) {
        self.title = title.uppercased()
    }
    
    // MARK: - Private methods
    
    private func setupCollectinView() {
        rootView.сollectionView.register(ListViewCell.self, forCellWithReuseIdentifier: ListViewCell.reuseId)
        rootView.сollectionView.bounces = false
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
        // add BarButtonItem to rightBarButtonItems
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart", tintColor: .appBlack, pointSize: 19, weight: .semibold),
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped))
    }
    
    @objc private func cartButtonTapped() {
        presenter.cartButtonTapped()
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.reuseId, for: indexPath)
        
        if let cell = cell as? ListViewCell {
            let title = presenter.getTitle(forRow: indexPath.row)
            cell.setTitle(title: title)
        }
        
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelect(row: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
