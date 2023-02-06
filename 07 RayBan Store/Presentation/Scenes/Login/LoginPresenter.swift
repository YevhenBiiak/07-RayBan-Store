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
    func display(error: LoginError)
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
        await withHandler {
            let loginRequest = LoginRequest(email: email, password: password)
            let user = try await authUseCase.execute(loginRequest)
            await router.presentProducts(user: user)
        }
    }
    
    func loginWithFacebookButtonTapped() async {
        await withHandler {
            let user = try await authUseCase.executeLoginWithFacebookRequest()
            await router.presentProducts(user: user)
        }
    }
    
    func createAccountButtonTapped() async {
        await router.presentRegistrationScene()
    }
    
    func forgotPasswordButtonTapped() async {
        // router.presentForgotPasswordScene()
    }
}

// MARK: - Private extension for helper methods

private extension LoginPresenterImpl {
    
    func withHandler(_ code: () async throws -> Void) async {
        do    { return try await code() }
        catch { await handle(error) }
    }
    
    func handle(_ error: Error) async {
        if let error = error as? AuthUseCaseError {
            switch error {
            // email errors
            case .emailValueIsEmpty, .emailFormatIsWrong, .invalidEmail:
                await view?.display(error: .emailError(error.localizedDescription))
            // password errors
            case .passwordValueIsEmpty, .passwordLengthIsWrong, .weakPassword, .wrongPassword:
                await view?.display(error: .passwordError(error.localizedDescription))
            // login errors
            case .userNotFound:
                print(error, error.localizedDescription)
                await view?.display(error: .userNotFound(error.localizedDescription))
            // facebook errors
            case .facebookError(let error):
                await view?.display(error: .facebookError(error.localizedDescription))
            // irrelevant errors in this case
            case .fbLoginWasCancelled, .firstNameValueIsEmpty, .lastNameValueIsEmpty, .emailAlreadyInUse, .notAcceptedPolicy, .passwordsDoNotMatch:
                break
            }
            return
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}

enum LoginError {
    case emailError(String)
    case passwordError(String)
    case userNotFound(String)
    case facebookError(String)
    
    var title: String { "Error" }
    
    var message: String {
        switch self {
        case .emailError(let message):    return message
        case .passwordError(let message): return message
        case .userNotFound(let message):  return message
        case .facebookError(let message): return message
        }
    }
}
