//
//  LoginViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 06.09.2022.
//

import UIKit

class LoginViewController: UIViewController, LoginView {
    
    var configurator: LoginConfigurator!
    var presenter: LoginPresenter!
    var rootView: LoginRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(loginViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Add actions
        rootView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        rootView.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        rootView.loginWithFacebookButton.addTarget(self, action: #selector(loginWithFacebookButtonTapped), for: .touchUpInside)
        rootView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func display(error: LoginError) {
        switch error {
        case .emailError:
            rootView.emailTextField.triggerRequirements(with: error.message)
        case .passwordError:
            rootView.passwordTextField.triggerRequirements(with: error.message)
        case .userNotFound:
            showWarning(with: error.message)
        case .facebookError:
            showAlert(title: error.title, message: error.message)
        }
    }
    
    @objc private func loginButtonTapped() {
        guard let email = rootView.emailTextField.text,
              let password = rootView.passwordTextField.text else { return }
        Task { await presenter.loginButtonTapped(email: email, password: password) }
    }
    
    @objc private func forgotPasswordButtonTapped() {
        Task { await presenter.forgotPasswordButtonTapped() }
    }
    
    @objc private func loginWithFacebookButtonTapped() {
        Task { await presenter.loginWithFacebookButtonTapped() }
    }
    
    @objc private func createAccountButtonTapped() {
        Task { await presenter.createAccountButtonTapped() }
    }
}
