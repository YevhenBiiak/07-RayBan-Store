//
//  ForgotPasswordRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.02.2023.
//

import UIKit
import Stevia

class ForgotPasswordRootView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = "FORGOT PASSWORD"
        label.font = UIFont.Oswald.bold.withSize(32)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = "Ray-Ban password assistance."
        label.font = UIFont.Lato.bold
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.text = "Please enter your E-mail address as used in your Ray-Ban account below."
        label.font = UIFont.Lato.regular
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    let emailTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .continue
        textField.attributedPlaceholder = NSAttributedString(string: "E-mail adress*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.tintColor = UIColor.appWhite
        button.backgroundColor = UIColor.appBlack
        button.titleLabel?.font = UIFont.Oswald.medium
        button.setTitle("SUBMIT", for: .normal)
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
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        // add subviews
        subviews(
            titleLabel,
            subtitleLabel,
            textLabel,
            emailTextField,
            submitButton,
            createAccountLabel,
            createAccountButton
        )
        
        titleLabel.Top == safeAreaLayoutGuide.Top + 30
        
        titleLabel.width(80%).centerHorizontally()
        subtitleLabel.width(80%).centerHorizontally().Top == titleLabel.Bottom + 50
        textLabel.width(80%).centerHorizontally().Top == subtitleLabel.Bottom + 16
        emailTextField.width(80%).centerHorizontally().Top == textLabel.Bottom + 80
        submitButton.width(80%).height(44).centerHorizontally().Top == emailTextField.Bottom + 80
        createAccountButton.right(10%).CenterY == createAccountLabel.left(10%).CenterY
        
        createAccountButton.Bottom == safeAreaLayoutGuide.Bottom - 30
    }
}

extension ForgotPasswordRootView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitButton.sendActions(for: .touchUpInside)
        return true
    }
}
