//
//  CategoriesRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.09.2022.
//

import UIKit
import Stevia

class CategoriesRootView: UIView {
    
    enum Section: Int, Hashable, CaseIterable {
        case gender
        case style
    }
    
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
        return UICollectionViewCompositionalLayout(sectionProvider: {
            [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .gender: return self?.genderSectionLayout()
            case .style:   return self?.styleSectionLayout() }
        })
    }
    
    private func genderSectionLayout() -> NSCollectionLayoutSection {
        
        let leadingItem = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1.0)))
        
        let centralItem = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalHeight(1.0)))

        let trailingItem = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1.0)))
        
        let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)),
            subitems: [leadingItem, centralItem, trailingItem])
        
        let bottomItem = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160)),
            subitems: [topGroup, bottomItem])

        return NSCollectionLayoutSection(group: group)
    }
    
    private func styleSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
