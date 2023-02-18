//
//  ForgotPasswordPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.02.2023.
//

@MainActor
protocol ForgotPasswordRouter {
    func dismiss(animated: Bool)
    func presentRegistrationScene()
}

@MainActor
protocol ForgotPasswordView: AnyObject {
    func display(emailFiledError: String)
    func displayWarning(message: String)
    func displayAlert(title: String, message: String)
}

protocol ForgotPasswordPresenter {
    func submitButtonTapped(email: String) async throws
    func createAccountButtonTapped() async
}

class ForgotPasswordPresenterImpl {
    
    private weak var view: ForgotPasswordView?
    private let router: ForgotPasswordRouter
    private let authUseCase: AuthUseCase
    
    init(view: ForgotPasswordView?, authUseCase: AuthUseCase, router: ForgotPasswordRouter) {
        self.view = view
        self.authUseCase = authUseCase
        self.router = router
    }
}

extension ForgotPasswordPresenterImpl: ForgotPasswordPresenter {
    
    func submitButtonTapped(email: String) async {
        await with(errorHandler) {
            let forgotPasswordRequest = ForgotPasswordRequest(email: email)
            try await authUseCase.execute(forgotPasswordRequest)
            await view?.displayAlert(title: "Success", message: "Password reset request was sent successfully. Please check your email to reset your password")
            await router.dismiss(animated: true)
        }
    }
    
    func createAccountButtonTapped() async {
        await router.presentRegistrationScene()
    }
}

// MARK: - Private extension for helper methods

private extension ForgotPasswordPresenterImpl {
    
    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayAlert(title: "Error", message: error.localizedDescription)
                
            // email errors
            case .emailValueIsEmpty,
                 .emailFormatIsWrong,
                 .invalidEmail:          await view?.display(emailFiledError: error.localizedDescription)

            // auth errors
            case .userNotFound,
                 .invalidRecipientEmail,
                 .facebookError:         await view?.displayWarning(message: error.localizedDescription)

            case .unknown:
                fatalError(error.localizedDescription)
            default:
                print("Irrelevant error for Forgot Password:", error.localizedDescription)
            }
            return
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}
