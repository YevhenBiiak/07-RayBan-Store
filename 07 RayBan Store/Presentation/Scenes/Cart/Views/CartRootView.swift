//
//  CartRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import UIKit
import Stevia

class CartRootView: UIView {
    
    private enum Section: Int, Hashable, CaseIterable {
        case cartItems
        case shippingMethod
        case orderSummary
    }
    
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
        return UICollectionViewCompositionalLayout(sectionProvider: {
            [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .cartItems:      return self?.itemsSectionLayout()
            case .shippingMethod: return self?.shippingSectionLayout()
            case .orderSummary:   return self?.summarySectionLayout() }
        })
    }
    
    private func itemsSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(130)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }

    private func shippingSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }

    private func summarySectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
