//
//  LoginRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import UIKit
import Stevia

class LoginRootView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appBlack,
            .font: UIFont.Oswald.bold.withSize(32)
        ]
        let attrString = NSAttributedString(string: "LOGIN", attributes: attributes)
        let label = UILabel()
        label.attributedText = attrString
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appBlack,
            .font: UIFont.Lato.regular
        ]
        let attrString = NSAttributedString(string: "Login with your account details", attributes: attributes)
        let label = UILabel()
        label.attributedText = attrString
        return label
    }()
    
    let emailTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(string: "E-mail address*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let passwordTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.isSecureTextEntry = true
        textField.returnKeyType = .continue
        textField.attributedPlaceholder = NSAttributedString(string: "Password*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.tintColor = UIColor.appDarkGray
        let title = "Forgot Password?"
        button.setAttributedTitle(title.underlined, for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = UIColor.appWhite
        config.imagePadding = 8
        config.title = "LOG IN"
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.Oswald.medium
            return outgoing
        }
        
        let button = UIButton(configuration: config)
        button.backgroundColor = .appBlack
        return button
    }()
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = "OR"
        label.font = UIFont.Lato.regular
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
    
    let createAccountLabel: UILabel = {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appBlack,
            .font: UIFont.Lato.regular.withSize(17)
        ]
        let attrString = NSAttributedString(string: "Not a member?", attributes: attributes)
        let label = UILabel()
        label.attributedText = attrString
        return label
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.appDarkGray
        button.titleLabel?.font = UIFont.Lato.regular.withSize(16)
        let title = "CREATE AN ACCOUNT"
        button.setAttributedTitle(title.underlined, for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.appWhite
        emailTextField.delegate = self
        passwordTextField.delegate = self
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        // add subviews
        subviews(
            scrollView.subviews(
                contentView.subviews(
                    logoImageView,
                    titleLabel,
                    subtitleLabel,
                    emailTextField,
                    passwordTextField,
                    forgotPasswordButton,
                    loginButton,
                    orLabel,
                    loginWithFacebookButton,
                    createAccountLabel,
                    createAccountButton
                )
            )
        )
        
        // set constraints
        scrollView.Left   == safeAreaLayoutGuide.Left
        scrollView.Right  == safeAreaLayoutGuide.Right
        scrollView.Top    == safeAreaLayoutGuide.Top
        scrollView.Bottom == safeAreaLayoutGuide.Bottom
        
        contentView.fillHorizontally().fillVertically().width(100%)
        
        logoImageView.Top == contentView.Top + 30
        
        logoImageView.width(40%).centerHorizontally().Height == 72.9 % logoImageView.Width
        titleLabel.width(80%).centerHorizontally().Top == logoImageView.Bottom + 50
        subtitleLabel.width(80%).centerHorizontally().Top == titleLabel.Bottom + 50
        emailTextField.width(80%).height(44).centerHorizontally().Top == subtitleLabel.Bottom + 80
        passwordTextField.width(80%).height(44).centerHorizontally().Top == emailTextField.Bottom + 30
        forgotPasswordButton.right(10%).Top == passwordTextField.Bottom + 15
        loginButton.width(80%).height(44).centerHorizontally().Top == forgotPasswordButton.Bottom + 60
        orLabel.centerHorizontally().Top == loginButton.Bottom + 15
        loginWithFacebookButton.width(80%).height(44).centerHorizontally().Top == orLabel.Bottom + 15
        createAccountLabel.left(10%).Top == loginWithFacebookButton.Bottom + 60
        createAccountButton.right(10%).CenterY == createAccountLabel.CenterY
        
        createAccountButton.Bottom == contentView.Bottom - 30
    }
}

extension LoginRootView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            _ = passwordTextField.becomeFirstResponder()
        case passwordTextField:
            _ = passwordTextField.resignFirstResponder()
            loginButton.sendActions(for: .touchUpInside)
        default: break }
        return true
    }
}
