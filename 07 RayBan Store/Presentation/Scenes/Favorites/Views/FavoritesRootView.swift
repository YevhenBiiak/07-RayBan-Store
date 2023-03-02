//
//  FavoritesRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import UIKit
import Stevia

class FavoritesRootView: UIView {
    
    var сollectionView: UICollectionView!
    
    // MARK: - Initializers and overridden methods
    
    init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        сollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        subviews( сollectionView )
        сollectionView.fillContainer()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(130)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
