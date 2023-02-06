//
//  RegistrationRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

import UIKit
import Stevia

class RegistrationRootView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = "CREATE ACCOUNT"
        label.font = UIFont.Oswald.bold.withSize(32)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = """
        Create an account and unlock all the privileges of The Ones. If you're registering for the first time, you can claim an exclusive welcome gift. \n
        As a The Ones member, you will have privileged access to events, pre-releases and limited edition collections. \n
        And that's not all: you can order more quickly, track your orders, receive Ray-Ban e-mails and submit reviews.
        """
        label.font = UIFont.Lato.regular
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    let loginWithFacebookButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.tintColor = UIColor.appWhite
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.Oswald.medium
        button.setTitle("LOGIN WITH FACEBOOK", for: .normal)
        return button
    }()
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = "Or register with your email address"
        label.font = UIFont.Lato.regular
        return label
    }()
    
    let firstNameTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appDarkGray
        textField.returnKeyType = .next
        textField.attributedPlaceholder = NSAttributedString(string: "First name", attributes: [.foregroundColor: UIColor.appBlack])
        return textField
    }()
    
    let lastNameTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appDarkGray
        textField.returnKeyType = .next
        textField.attributedPlaceholder = NSAttributedString(string: "Last name", attributes: [.foregroundColor: UIColor.appBlack])
        return textField
    }()
    
    let emailTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appDarkGray
        textField.returnKeyType = .next
        textField.attributedPlaceholder = NSAttributedString(string: "E-mail adress", attributes: [.foregroundColor: UIColor.appBlack])
        return textField
    }()
    
    let passwordTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appDarkGray
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: UIColor.appBlack])
        return textField
    }()
    
    let conformPasswordTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appDarkGray
        textField.returnKeyType = .continue
        textField.attributedPlaceholder = NSAttributedString(string: "Conform password", attributes: [.foregroundColor: UIColor.appBlack])
        return textField
    }()
    
    let policyCheckmarkButton = CheckboxButton(scale: .large)
    
    let policyCheckmarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = "I have read and understood the Privacy Policy concerning the processing of my personal data."
        label.font = UIFont.Lato.regular.withSize(12)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.tintColor = UIColor.appWhite
        button.backgroundColor = UIColor.appBlack
        button.titleLabel?.font = UIFont.Oswald.medium
        button.setTitle("CREATE ACCOUNT", for: .normal)
        return button
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.font = UIFont.Lato.regular
        label.text = "Already a member?"
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.appDarkGray
        let title = "LOGIN"
        button.setAttributedTitle(title.underlined, for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()

    // MARK: - Initializers and overridden methods
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.appWhite
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        conformPasswordTextField.delegate = self
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        
        [firstNameTextField, lastNameTextField, emailTextField,
         passwordTextField, conformPasswordTextField
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        // add subviews
        subviews(
            scrollView.subviews(
                contentView.subviews(
                    titleLabel, subtitleLabel, loginWithFacebookButton, orLabel, stackView,
                    policyCheckmarkButton, policyCheckmarkLabel, createAccountButton,
                    loginLabel, loginButton
                )
            )
        )
        
        // set constraints
        scrollView.fillHorizontally().fillVertically()
        contentView.fillHorizontally().fillVertically().width(100%)
        
        titleLabel.Top == contentView.Top + 30
        
        titleLabel.width(80%).centerHorizontally()
        subtitleLabel.width(80%).centerHorizontally().Top == titleLabel.Bottom + 30
        loginWithFacebookButton.width(60%).height(44).centerHorizontally().Top == subtitleLabel.Bottom + 50
        orLabel.centerHorizontally().Top == loginWithFacebookButton.Bottom + 30
        stackView.width(80%).centerHorizontally().Top == orLabel.Bottom + 30
        policyCheckmarkButton.left(10%).Top == stackView.Bottom + 50
        policyCheckmarkLabel.CenterY == policyCheckmarkButton.CenterY
        policyCheckmarkLabel.right(10%).Left == policyCheckmarkButton.Right
        createAccountButton.width(80%).height(44).centerHorizontally().Top == policyCheckmarkLabel.Bottom + 30
        loginLabel.left(10%).Top == createAccountButton.Bottom + 60
        loginButton.CenterY == loginLabel.CenterY
        loginButton.Left == loginLabel.Right + 8
        
        loginButton.Bottom == contentView.Bottom - 30
    }
}

extension RegistrationRootView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            _ = lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            _ = emailTextField.becomeFirstResponder()
        case emailTextField:
            _ = passwordTextField.becomeFirstResponder()
        case passwordTextField:
            _ = conformPasswordTextField.becomeFirstResponder()
        case conformPasswordTextField:
            _ = conformPasswordTextField.resignFirstResponder()
        default: break }
        return true
    }
}
