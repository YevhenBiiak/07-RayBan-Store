//
//  RegistrationViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    var configurator: RegistrationConfigurator!
    var presenter: RegistrationPresenter!
    var rootView: RegistrationRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(registrationViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Add actions
        rootView.loginWithFacebookButton.addTarget(self, action: #selector(loginWithFacebookButtonTapped), for: .touchUpInside)
        rootView.policyCheckmarkButton.addTarget(self, action: #selector(policyCheckmarTapped), for: .touchUpInside)
        rootView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        rootView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginWithFacebookButtonTapped() {
        Task { await presenter.loginWithFacebookButtonTapped() }
    }
    
    @objc private func policyCheckmarTapped() {
        
    }
    
    @objc private func createAccountButtonTapped() {
        guard let firstName = rootView.firstNameTextField.text,
              let lastName = rootView.lastNameTextField.text,
              let email = rootView.emailTextField.text,
              let password = rootView.passwordTextField.text,
              let conformPassword = rootView.conformPasswordTextField.text else { return }
        let acceptedPolicy = rootView.policyCheckmarkButton.isChecked
        let params = RegistrationParameters(firstName: firstName, lastName: lastName, email: email, password: password)
        
        Task { await presenter.createAccountButtonTapped(
            registreationParameters: params,
            conformPassword: conformPassword,
            acceptedPolicy: acceptedPolicy)
        }
    }
    
    @objc private func loginButtonTapped() {
        Task { await presenter.loginButtonTapped() }
    }
}

extension RegistrationViewController: RegistrationView {
    
    func display(error: RegistrationError) {
        switch error {
        case .firstNameError:
            rootView.firstNameTextField.triggerRequirements(with: error.message)
        case .lastNameError:
            rootView.lastNameTextField.triggerRequirements(with: error.message)
        case .emailError:
            rootView.emailTextField.triggerRequirements(with: error.message)
        case .passwordError:
            rootView.passwordTextField.triggerRequirements(with: error.message)
        case .passwordsDoNotMatch:
            rootView.passwordTextField.triggerRequirements(with: "")
            showWarning(with: error.message)
        case .emailAlreadyInUse, .notAcceptedPolicy:
            showWarning(with: error.message)
        case .facebookError:
            showAlert(title: error.title, message: error.message)
        }
    }
}
