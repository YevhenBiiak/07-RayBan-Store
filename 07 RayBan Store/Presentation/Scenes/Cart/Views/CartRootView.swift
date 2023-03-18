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
        case items
        case summary
    }
        
    var сollectionView: UICollectionView!
    
    let activityIndicator = ActivityIndicatorView()
    
    let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.image = UIImage(named: "image_placeholder")
        view.title = "There are no products in your shopping bag."
        return view
    }()

    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        setupViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Private methods
    
    private func setupViews() {
        сollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    }
    
    private func configureLayout() {
        
        subviews(
            сollectionView.subviews (
                emptyStateView,
                activityIndicator
            )
        )
        
        сollectionView.fillContainer()
        emptyStateView.Left == safeAreaLayoutGuide.Left
        emptyStateView.Right == safeAreaLayoutGuide.Right
        emptyStateView.Bottom == сollectionView.CenterY
        
        activityIndicator.CenterX == safeAreaLayoutGuide.CenterX
        activityIndicator.CenterY == safeAreaLayoutGuide.CenterY
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: {
            [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .items:      return self?.itemsSectionLayout()
            case .summary:   return self?.summarySectionLayout() }
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

    private func summarySectionLayout() -> NSCollectionLayoutSection {
        
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
