//
//  PersonalDetailsViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

import UIKit

protocol PersonalDetailsViewModel {
    var firstName: String { get }
    var lastName: String { get }
    var phoneNumber: String { get }
    var shippingAddress: String { get }
    var emailAddress: String { get }
}

class PersonalDetailsViewController: UIViewController {
    
    var configurator: PersonalDetailsConfigurator!
    var presenter: PersonalDetailsPresenter!
    var rootView: PersonalDetailsRootView!
    
    private var viewModel: PersonalDetailsViewModel? {
        didSet {
            rootView.firstNameTextField.text = viewModel?.firstName
            rootView.lastNameTextField.text = viewModel?.lastName
            rootView.phoneTextField.text = viewModel?.phoneNumber
            rootView.addressTextField.text = viewModel?.shippingAddress
            rootView.emailTextField.text = viewModel?.emailAddress
        }
    }
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(personalDetailsViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Task { await presenter.viewDidLoad() }
    }
    
    private func setupViews() {
        hideKeyboardWhenTappedAround()
        observeKeyboardNotification(for: rootView.scrollView.bottomConstraint, adjustOffsetFor: rootView.scrollView)
        
        let button = UIButton(type: .system)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(.appRed, for: .normal)
        button.titleLabel?.font = .Lato.medium
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func logoutButtonTapped() {
        showDialogAlert(title: "Confirm", message: "Are you sure you want to log out?", confirmTitle: "LOG OUT") { [weak self] in
            Task { await self?.presenter.logoutButtonTapped() }
        }
    }
}

extension PersonalDetailsViewController: PersonalDetailsView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(viewModel: PersonalDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    func displayConfirmationAlert(title: String, message: String, completion: () -> Void) {
        
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
}
