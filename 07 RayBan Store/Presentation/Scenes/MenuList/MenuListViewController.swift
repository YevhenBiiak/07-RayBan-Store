//
//  MenuListViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import UIKit

class MenuListViewController: UIViewController, MenuListView {
    
    var configurator: MenuListConfigurator!
    var presenter: MenuListPresenter!
    var rootView: MenuListRootView!
    
    override func loadView() {
        configurator.configure(menuListViewController: self)
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectinView()
    }
    
    // MARK: - Private methods
    
    private func setupCollectinView() {
        rootView.menuCollectionView.register(MenuListViewCell.self, forCellWithReuseIdentifier: MenuListViewCell.identifier)
        rootView.menuCollectionView.bounces = false
        rootView.menuCollectionView.delegate = self
        rootView.menuCollectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let cartButton = UIButton.buttonWithSFImage(name: "cart", color: UIColor.appBlack, size: 17, weight: .semibold)
        
        cartButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter.cartButtonTapped()
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: cartButton)
        ]
    }
}

extension MenuListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuListViewCell.identifier, for: indexPath)
        
        if let cell = cell as? MenuListViewCell {
            let text = presenter.getTitle(forRow: indexPath.row)
            cell.setText(text: text)
        }
        
        return cell
    }
}

extension MenuListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
