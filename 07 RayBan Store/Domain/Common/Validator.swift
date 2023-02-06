//
//  Validator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 06.09.2022.
//

import Foundation

/// Responsible to validate different data.
struct Validator {
    
    private static let passwordRequiredLength = 8
    
    // MARK: Public methods
    
    static func validateEmail(_ value: String?) throws {
        guard let email = value, !email.isEmpty else {
            throw ValidationError.emailValueIsEmpty
        }
        if !isValidEmail(email) {
            throw ValidationError.emailFormatIsWrong
        }
    }
    
    static func validatePassword(_ value: String?) throws {
        guard let password = value, !password.isEmpty else {
            throw ValidationError.passwordValueIsEmpty
        }
        if password.count < passwordRequiredLength {
            throw ValidationError.passwordLengthIsWrong(passwordRequiredLength)
        }
    }
    
    static func validateFirstName(_ value: String?) throws {
        guard let firstName = value, !firstName.isEmpty else {
            throw ValidationError.firstNameValueIsEmpty
        }
    }
    
    static func validateLastName(_ value: String?) throws {
        guard let lastName = value, !lastName.isEmpty else {
            throw ValidationError.lastNameValueIsEmpty
        }
    }
    
    // MARK: Private methods
    
    private static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

enum ValidationError: LocalizedError {
    case emailValueIsEmpty
    case passwordValueIsEmpty
    case firstNameValueIsEmpty
    case lastNameValueIsEmpty
    case emailFormatIsWrong
    case passwordLengthIsWrong(Int)
    
    var errorDescription: String? {
        switch self {
        case .emailValueIsEmpty:
            return "Email is empty. Please fill it."
        case .passwordValueIsEmpty:
            return "Password is empty. Please fill it."
        case .firstNameValueIsEmpty:
            return "First name is empty. Please fill it."
        case .lastNameValueIsEmpty:
            return "Last name is empty. Please fill it."
        case .emailFormatIsWrong:
            return "Email has wrong format. Please edit it."
        case .passwordLengthIsWrong(let length):
            return "Password must have minimum \(length) symbols."
        }
    }
}
