//
//  ListRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import UIKit
import Stevia

class ListRootView: UIView {
    
    var сollectionView: UICollectionView!

    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        сollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        subviews( сollectionView )
        сollectionView.fillContainer()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = -1
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
