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
    
    let activityIndicator = ActivityIndicatorView()
    
    let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.image = UIImage(named: "image_placeholder")
        view.title = "There are no products in your favorite list."
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
