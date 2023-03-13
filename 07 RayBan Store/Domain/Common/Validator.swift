//
//  Validator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 06.09.2022.
//

import Foundation

struct Validator {
    
    private static let passwordRequiredLength = 6
    
    // MARK: Public methods
    
    static func validateFirstName(_ value: String?) throws {
        guard let firstName = value, !firstName.isEmpty else {
            throw AppError.firstNameValueIsEmpty
        }
    }
    
    static func validateLastName(_ value: String?) throws {
        guard let lastName = value, !lastName.isEmpty else {
            throw AppError.lastNameValueIsEmpty
        }
    }
    
    static func validatePhone(_ phone: String) throws {
        if phone.isEmpty {
            throw AppError.phoneValueIsEmpty
        }
        if Int(phone.replacingOccurrences(of: "+", with: "")) == nil {
            throw AppError.phoneFormatIsWrong
        }
    }
    
    static func validateAddress(_ address: String) throws {
        if address.isEmpty {
            throw AppError.addressValueIsEmpty
        }
    }
    
    static func validatePasswordsMatch(_ password: String, and conformPassrowd: String) throws {
        guard password == conformPassrowd else {
            throw AppError.passwordsDoNotMatch
        }
    }
    
    static func validateEmail(_ value: String?) throws {
        guard let email = value, !email.isEmpty else {
            throw AppError.emailValueIsEmpty
        }
        if !isValidEmail(email) {
            throw AppError.emailFormatIsWrong
        }
    }
    
    static func validatePassword(_ value: String?) throws {
        guard let password = value, !password.isEmpty else {
            throw AppError.passwordValueIsEmpty
        }
        if password.count < passwordRequiredLength {
            throw AppError.passwordLengthIsWrong
        }
    }
    
    static func validatePolicyAcceptance(_ acceptedPolicy: Bool) throws {
        guard acceptedPolicy else {
            throw AppError.notAcceptedPolicy
        }
    }
    
    // MARK: Private methods
    
    private static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
