//
//  EditCredentialsRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 15.03.2023.
//

import UIKit
import Stevia

class EditCredentialsRootView: UIView {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark", pointSize: 20, weight: .medium)
        button.setImage(image, for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Oswald.bold.withSize(19)
        label.textAlignment = .center
        label.text = "CHANGE CREDENTIAL"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Lato.regular
        label.textColor = .appDarkGray
        label.textAlignment = .center
        label.text = "This is the credential you use to login in app."
        return label
    }()
    
    let newValueTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "New value*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let confirmValueTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Confirm New value*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let passwordTextField: RequiredTextField = {
        let textField = RequiredTextField()
        textField.font = UIFont.Lato.regular
        textField.textColor = UIColor.appBlack
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Current password*", attributes: [.foregroundColor: UIColor.appDarkGray])
        return textField
    }()
    
    let confirmButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = UIColor.appWhite
        config.imagePadding = 8
        config.title = "CONFIRM"
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.Oswald.bold
            return outgoing
        }
        
        let button = UIButton(configuration: config)
        button.backgroundColor = .appBlack
        return button
    }()
    
    // MARK: - Initializers and overridden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appBlack.withAlphaComponent(0.8)
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        let fieldsStack = UIStackView()
        fieldsStack.axis = .vertical
        fieldsStack.distribution = .fill
        fieldsStack.spacing = 30
        
        [newValueTextField, confirmValueTextField, passwordTextField].forEach {
            fieldsStack.addArrangedSubview($0)
        }
        
        subviews(
            contentView.subviews(
                closeButton,
                titleLabel,
                subtitleLabel,
                fieldsStack,
                confirmButton
            )
        )
        
        contentView.width(90%).centerInContainer()
        closeButton.top(14).right(14)
        titleLabel.width(80%).centerHorizontally().top(20)
        subtitleLabel.width(80%).centerHorizontally().Top == titleLabel.Bottom + 16
        fieldsStack.width(80%).centerHorizontally().Top == subtitleLabel.Bottom + 36
        confirmButton.width(90%).height(44).centerHorizontally().bottom(14).Top == fieldsStack.Bottom + 50
    }
}
