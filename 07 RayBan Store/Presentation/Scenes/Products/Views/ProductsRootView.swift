//
//  ProductsRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation
import Stevia

class ProductsRootView: UIView {
    
    var productsCollectionView: UICollectionView!
    
    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        setupCollectinView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupCollectinView() {
        productsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: creatrLayout())
        
        subviews( productsCollectionView )
        productsCollectionView.width(100%).height(100%)
    }
    
    private func creatrLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.4875),
            heightDimension: .estimated(130)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(130)), subitems: [item])
        group.interItemSpacing = .flexible(1)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
