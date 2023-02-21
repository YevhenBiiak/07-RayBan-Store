//
//  ProductsRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit
import Stevia

class ProductsRootView: UIView {
    
    var collectionView: UICollectionView!
    
    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        configureCollectinView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configureCollectinView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        subviews( collectionView )
        collectionView.width(100%).height(100%)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.4875),
            heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.78)),
            subitems: [item])
        
        group.interItemSpacing = .flexible(1)
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)),
            elementKind: HeaderReusableView.elementKind,
            alignment: .top)
        
        section.boundarySupplementaryItems = [headerSection]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
