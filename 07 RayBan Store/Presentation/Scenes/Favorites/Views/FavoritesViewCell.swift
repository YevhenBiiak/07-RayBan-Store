//
//  FavoritesViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import UIKit
import Stevia

protocol FavoriteItemViewModel {
    var modelID: ModelID { get }
    var name: String { get }
    var price: String { get }
    var frame: String { get }
    var lense: String { get }
    var size: String { get }
    var imageData: Data { get }
    var favoriteButtonTapped: (ModelID) async -> Void  { get }
}

class FavoritesViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium
        label.numberOfLines = 2
        label.text = "NAME NAME NAME NAME"
        return label
    }()
    
    private let frameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular.withSize(12)
        label.text = "Frame color: gold"
        return label
    }()
    
    private let lenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular.withSize(12)
        label.text = "Lense colro: green"
        return label
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular.withSize(12)
        label.text = "Size: Standart"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium.withSize(18)
        label.textAlignment = .right
        label.text = "$ 129.00"
        return label
    }()
    
    let favoriteButton: CheckboxButton = {
        let checkedImage = UIImage(systemName: "heart.fill")!
            .withConfiguration(UIImage.SymbolConfiguration(paletteColors: [UIColor.appBlack]))
        let uncheckedImage = UIImage(systemName: "heart")!
            .withConfiguration(UIImage.SymbolConfiguration(paletteColors: [UIColor.appBlack]))
        let button = CheckboxButton(checkedImage: checkedImage, uncheckedImage: uncheckedImage, scale: .large)
        return button
    }()
    
    var viewModel: FavoriteItemViewModel? {
        didSet {
            guard let viewModel else { return }
            setImage(with: viewModel.imageData)
            nameLabel.text = viewModel.name
            frameLabel.text = viewModel.frame
            lenseLabel.text = viewModel.lense
            sizeLabel.text = viewModel.size
            priceLabel.text = viewModel.price
            favoriteButton.isChecked = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
        addBorder(at: .bottom, color: .appGray, width: 0.5)
        favoriteButton.addAction { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            Task { await viewModel.favoriteButtonTapped(viewModel.modelID) }
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setImage(with data: Data) {
        DispatchQueue.global().async {
            guard let image = UIImage(data: data)?.preparingForDisplay() else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func configureLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        
        [frameLabel, lenseLabel, sizeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        subviews(
            imageView,
            nameLabel,
            stackView,
            priceLabel,
            favoriteButton
        )
        
        imageView.left(0).top(0).bottom(0).heightEqualsWidth()
        nameLabel.top(8).Left == imageView.Right + 8
        priceLabel.top(8).right(16).Left == nameLabel.Right + 8
        stackView.Left == imageView.Right + 8
        stackView.bottom(>=8).Top == nameLabel.Bottom + 8
        favoriteButton.right(8).bottom(16).Left == stackView.Right + 8
        
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)
        favoriteButton.setContentHuggingPriority(.required, for: .horizontal)
    }
}
