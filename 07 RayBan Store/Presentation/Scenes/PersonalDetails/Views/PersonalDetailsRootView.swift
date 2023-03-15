//
//  PersonalDetailsRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

import UIKit
import Stevia

class PersonalDetailsRootView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium.withSize(18)
        label.text = "PERSONAL DETAILS"
        return label
    }()

    let firstNameTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "First name*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()

    let lastNameTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Last name*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()

    let phoneTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Phone number*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()

    let addressTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Shipping address*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()

    let emailTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Email addres*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()

    let passwordTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.attributedPlaceholder = .init(string: "Password*", attributes: [.foregroundColor: UIColor.appDarkGray])
        textField.text = "0123456789"
        return textField
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.tintColor = UIColor.appWhite
        button.backgroundColor = UIColor.appBlack
        button.titleLabel?.font = UIFont.Oswald.bold
        button.setTitle("SAVE", for: .normal)
        return button
    }()

    // MARK: - Initializers and overridden methods
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .appWhite
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        
        [firstNameTextField, lastNameTextField, phoneTextField,
         addressTextField, emailTextField, passwordTextField
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        // add subviews
        subviews(
            scrollView.subviews(
                contentView.subviews(
                    titleLabel,
                    stackView,
                    saveButton
                )
            )
        )
        
        // set constraints
        scrollView.Left   == safeAreaLayoutGuide.Left
        scrollView.Right  == safeAreaLayoutGuide.Right
        scrollView.Top    == safeAreaLayoutGuide.Top
        scrollView.Bottom == safeAreaLayoutGuide.Bottom
        contentView.fillContainer().width(100%).Height >= 100 % scrollView.Height
        
        titleLabel.top(20).width(80%).centerHorizontally()
        stackView.width(80%).centerHorizontally().Top == titleLabel.Bottom + 50
        saveButton.width(80%).height(44).centerHorizontally().bottom(30).Top >= stackView.Bottom + 50
    }
}

extension PersonalDetailsRootView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
