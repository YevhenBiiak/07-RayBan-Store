//
//  LoginPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 05.09.2022.
//

import Foundation

@MainActor
protocol LoginRouter {
    func presentProducts(user: User)
    func presentRegistrationScene()
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

@MainActor
protocol LoginView: AnyObject {
    func displayError(title: String, message: String, completion: (() -> Void)?)
}

protocol LoginPresenter {
    func loginButtonTapped(email: String, password: String) async
    func loginWithFacebookButtonTapped() async
    func createAccountButtonTapped() async
    func forgotPasswordButtonTapped() async
}

class LoginPresenterImpl {
    
    private weak var view: LoginView?
    private let router: LoginRouter
    private let authUseCase: AuthUseCase
    
    init(view: LoginView?, authUseCase: AuthUseCase, router: LoginRouter) {
        self.view = view
        self.authUseCase = authUseCase
        self.router = router
    }
}

extension LoginPresenterImpl: LoginPresenter {
    
    func loginButtonTapped(email: String, password: String) async {
        let loginRequest = LoginRequest(email: email, password: password)
        do {
            let user = try await authUseCase.execute(loginRequest)
            await router.presentProducts(user: user)
        } catch {
            await view?.displayError(title: "Error", message: error.localizedDescription, completion: nil)
        }
    }
    
    func loginWithFacebookButtonTapped() async {
        do {
            let user = try await authUseCase.executeLoginWithFacebookRequest()
            await router.presentProducts(user: user)
        } catch {
            await view?.displayError(title: "Error", message: error.localizedDescription, completion: nil)
        }
    }
    
    func createAccountButtonTapped() async {
        await router.presentRegistrationScene()
    }
    
    func forgotPasswordButtonTapped() async {
        // router.presentForgotPasswordScene()
    }
}
