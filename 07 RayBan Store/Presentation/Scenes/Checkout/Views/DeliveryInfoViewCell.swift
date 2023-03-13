//
//  DeliveryInfoViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import UIKit
import Stevia

protocol DeliveryInfoViewModel {
    var firstName: String { get set }
    var lastName: String { get set }
    var emailAddress: String { get set }
    var phoneNumber: String { get set }
    var shippingAddress: String { get set }
    var firstNameError: String? { get set }
    var lastNameError: String? { get set }
    var emailError: String? { get set }
    var phoneError: String? { get set }
    var addressError: String? { get set }
    var paymentButtonTapped: (DeliveryInfoViewModel) async -> Void { get }
}

class DeliveryInfoViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium.withSize(18)
        label.text = "DELIVERY INFORMATION"
        return label
    }()
    
    let firstNameTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .next
        textField.attributedPlaceholder = NSAttributedString(string: "First name*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let lastNameTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .next
        textField.attributedPlaceholder = NSAttributedString(string: "Last name*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let emailTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(string: "E-mail adress*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let phoneTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .next
        textField.keyboardType = .numberPad
        textField.attributedPlaceholder = NSAttributedString(string: "Telephone number*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let addressTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .continue
        textField.attributedPlaceholder = NSAttributedString(string: "Shipping address*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    private let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBlack
        button.tintColor = .appWhite
        let image = UIImage(systemName: "applelogo")!
        button.setImage(image, for: .normal)
        button.setTitle(" Pay", for: .normal)
        return button
    }()
    
    var viewModel: DeliveryInfoViewModel? {
        didSet {
            guard let viewModel else { return }
            firstNameTextField.text = viewModel.firstName
            lastNameTextField.text = viewModel.lastName
            emailTextField.text = viewModel.emailAddress
            phoneTextField.text = viewModel.phoneNumber
            addressTextField.text = viewModel.shippingAddress
            if let error = viewModel.firstNameError {
                self.viewModel?.firstNameError = nil
                firstNameTextField.triggerRequirements(with: error)
            }
            if let error = viewModel.lastNameError {
                self.viewModel?.lastNameError = nil
                lastNameTextField.triggerRequirements(with: error)
            }
            if let error = viewModel.emailError {
                self.viewModel?.emailError = nil
                emailTextField.triggerRequirements(with: error)
            }
            if let error = viewModel.phoneError {
                self.viewModel?.phoneError = nil
                phoneTextField.triggerRequirements(with: error)
            }
            if let error = viewModel.addressError {
                self.viewModel?.addressError = nil
                addressTextField.triggerRequirements(with: error)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    private func setupViews() {
        addBorder(at: .top, color: .appGray, width: 0.5)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        
        firstNameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        paymentButton.addAction { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            Task { await viewModel.paymentButtonTapped(viewModel) }
        }
    }
    
    @objc private func textFieldEditingChanged(sender: UITextField) {
        switch sender {
        case firstNameTextField:
            viewModel?.firstName = sender.text ?? ""
        case lastNameTextField:
            viewModel?.lastName = sender.text ?? ""
        case emailTextField:
            viewModel?.emailAddress = sender.text ?? ""
        case phoneTextField:
            viewModel?.phoneNumber = sender.text ?? ""
        case addressTextField:
            viewModel?.shippingAddress = sender.text ?? ""
        default: break }
    }
    
    private func configureLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        
        [firstNameTextField, lastNameTextField, emailTextField,
         phoneTextField, addressTextField
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        subviews(
            titleLabel,
            stackView,
            paymentButton
        )
        
        let padding = 0.05 * frame.width
        titleLabel.fillHorizontally(padding: padding).top(padding)
        stackView.width(80%).centerHorizontally().Top == titleLabel.Bottom + 1.5 * padding
        paymentButton.fillHorizontally(padding: padding).height(44).bottom(30).Top == stackView.Bottom + 2 * padding
    }
}

extension DeliveryInfoViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            _ = lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            _ = emailTextField.becomeFirstResponder()
        case emailTextField:
            _ = phoneTextField.becomeFirstResponder()
        case phoneTextField:
            _ = addressTextField.becomeFirstResponder()
        case addressTextField:
            _ = addressTextField.resignFirstResponder()
            paymentButton.sendActions(for: .touchUpInside)
        default: break }
        return true
    }
}
