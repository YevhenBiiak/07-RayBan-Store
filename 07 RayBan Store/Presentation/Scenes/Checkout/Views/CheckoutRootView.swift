//
//  CheckoutRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import UIKit
import Stevia

class CheckoutRootView: UIView {
    
    private enum Section: Int, Hashable, CaseIterable {
        case items
        case details
        case info
    }
    
    var сollectionView: UICollectionView!
    
    // MARK: - Initializers and overridden methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Private methods
    
    private func configureLayout() {
        сollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        subviews(сollectionView)
        сollectionView.fillContainer()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: {
            [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }

            switch sectionKind {
            case .items:   return self?.itemsSectionLayout()
            case .details: return self?.detailsSectionLayout()
            case .info:    return self?.infoSectionLayout() }
        })
    }
    
    private func itemsSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(95)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(95)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }

    private func detailsSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(609)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(609)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }

    private func infoSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(220)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(220)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
