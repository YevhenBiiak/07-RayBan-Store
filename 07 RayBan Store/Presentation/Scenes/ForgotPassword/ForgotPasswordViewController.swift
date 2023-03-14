//
//  ForgotPasswordViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.02.2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    var configurator: ForgotPasswordConfigurator!
    var presenter: ForgotPasswordPresenter!
    var rootView: ForgotPasswordRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(forgotPasswordViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Add actions
        rootView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        rootView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
    }
    
    @objc private func submitButtonTapped() {
        guard let email = rootView.emailTextField.text else { return }
        Task { try await presenter.submitButtonTapped(email: email) }
    }
    
    @objc private func createAccountButtonTapped() {
        Task { await presenter.createAccountButtonTapped() }
    }
}

extension ForgotPasswordViewController: ForgotPasswordView {
    
    func display(emailFiledError: String) {
        rootView.emailTextField.triggerRequirements(with: emailFiledError)
    }
    
    func displayWarning(message: String) {
        showWarning(with: message)
    }
    
    func displayAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}
