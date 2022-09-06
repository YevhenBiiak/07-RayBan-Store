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
            throw ValidationError.valueIsEmpty("Email")
        }
        if !isValidEmail(email) {
            throw ValidationError.emailFormatIsWrong
        }
    }
    
    static func validatePassword(_ value: String?) throws {
        guard let password = value, !password.isEmpty else {
            throw ValidationError.valueIsEmpty("Password")
        }
        if password.count < passwordRequiredLength {
            throw ValidationError.passwordLengthIsWrong
        }
    }
    
    // MARK: Private methods
    
    private static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

extension Validator {
    /// Represents error type with detailed description.
    enum ValidationError: Error, Equatable {
        case emailFormatIsWrong
        case emailFormatIsDublicated
        case passwordLengthIsWrong
        case valueIsEmpty(String)
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .emailFormatIsWrong:
                return "Email has wrong format. Please edit it."
            case .emailFormatIsDublicated:
                return "This email is already used by other user. Please try another one."
            case .passwordLengthIsWrong:
                return "Password must have minimum \(passwordRequiredLength) symbols."
            case .valueIsEmpty(let value):
                return "\(value) is empty. Please fill it."
            default:
                return "Unknown error occured."
            }
        }
        
        static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
            switch (lhs, rhs) {
                case (.emailFormatIsWrong, .emailFormatIsWrong): return true
                case (.emailFormatIsDublicated, emailFormatIsDublicated): return true
                case (.passwordLengthIsWrong, .passwordLengthIsWrong): return true
                case let (.valueIsEmpty(l), .valueIsEmpty(r)): return l == r
                case (.unknown, .unknown) : return true
                default: return false
            }
        }
    }
}
