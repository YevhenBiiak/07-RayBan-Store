//
//  QuantityStepper.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 27.02.2023.
//

import UIKit

class QuantityStepper: UIControl {
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 5
        button.tintColor = .black
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 5
        button.tintColor = .black
        return button
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var widthAnchorConstraint: NSLayoutConstraint!
    private var heightAnchorConstraint: NSLayoutConstraint!
    
    private var sumbolConfig: UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(pointSize: font.pointSize * 0.8, weight: .bold)
    }
    
    var font = UIFont.systemFont(ofSize: 18) {
        didSet {
            updateUI()
            adjustSelfSize()
        }
    }
    
    var value: Int = 1 {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func draw(_ rect: CGRect) {
        adjustSelfSize()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1.5
        
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        updateUI()
    }
    
    @objc private func minusButtonTapped() {
        value = max(0, value - 1)
        sendActions(for: .touchUpInside)
        sendActions(for: .valueChanged)
    }
    
    @objc private func plusButtonTapped() {
        value += 1
        sendActions(for: .touchUpInside)
        sendActions(for: .valueChanged)
    }
    
    private func configureLayout() {
        adjustSelfSize()
        
        addSubview(minusButton)
        addSubview(valueLabel)
        addSubview(plusButton)
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor).isActive = true
        minusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
        minusButton.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        minusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 8).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor).isActive = true
        plusButton.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
    }
    
    private func updateUI() {
        let minusImage = value > 1
        ? UIImage(systemName: "minus", withConfiguration: sumbolConfig)
        : UIImage(systemName: "trash", withConfiguration: sumbolConfig)
        let plusImage = UIImage(systemName: "plus", withConfiguration: sumbolConfig)
        minusButton.setImage(minusImage, for: .normal)
        plusButton.setImage(plusImage, for: .normal)
        
        valueLabel.font = UIFont.boldSystemFont(ofSize: font.pointSize)
        valueLabel.text = "\(value)"
    }
    
    private func adjustSelfSize() {
        if translatesAutoresizingMaskIntoConstraints {
            frame.size = CGSize(width: font.pointSize * 6.5, height: font.pointSize * 2)
        } else {
            removeConstraints([widthAnchorConstraint, heightAnchorConstraint].compactMap({$0}))
            widthAnchorConstraint = widthAnchor.constraint(equalToConstant: font.pointSize * 6.5)
            heightAnchorConstraint = heightAnchor.constraint(equalToConstant: font.pointSize * 2)
            [widthAnchorConstraint, heightAnchorConstraint].forEach { $0.isActive = true }
        }
    }
}
