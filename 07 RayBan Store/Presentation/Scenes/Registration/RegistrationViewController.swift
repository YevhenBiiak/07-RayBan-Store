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
              let password = rootView.passwordTextField.text else { return }
        Task { await presenter.createAccountButtonTapped(firstName: firstName, lastName: lastName, email: email, password: password) }
    }
    
    @objc private func loginButtonTapped() {
        Task { await presenter.loginButtonTapped() }
    }
}

extension RegistrationViewController: RegistrationView {
    
    func displayError(_ error: Error) {
        
    }
}
