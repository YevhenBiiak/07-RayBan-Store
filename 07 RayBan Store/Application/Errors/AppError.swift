//
//  AppError.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.02.2023.
//

import Foundation

enum AppError: LocalizedError {
    /// The Internet connection appears to be offline.
    case networkError
    // Validation
    /// Email is empty. Please fill it.
    case emailValueIsEmpty
    /// Password is empty. Please fill it.
    case passwordValueIsEmpty
    /// First name is empty. Please fill it.
    case firstNameValueIsEmpty
    /// Last name is empty. Please fill it.
    case lastNameValueIsEmpty
    /// Email has wrong format.
    case emailFormatIsWrong
    /// Password must have minimum 6 symbols.
    case passwordLengthIsWrong
    /// You entered two different passwords. Please try again.
    case passwordsDoNotMatch
    /// Please read and accept the privacy policy
    case notAcceptedPolicy
    // Auth
    ///  This account are disabled.
    case operationNotAllowed
    /// The password must be 6 characters long or more.
    case weakPassword
    /// The password is invalid or the user does not have a password.
    case wrongPassword
    /// The email address is badly formatted.
    case invalidEmail
    /// The email template corresponding to this action contains invalid characters in its message.
    case invalidSender
    /// There is no user record corresponding to this identifier.
    case userNotFound
    /// The email address is already in use by another account.
    case emailAlreadyInUse
    /// An invalid recipient email address was sent in the request.
    case invalidRecipientEmail
    /// The facebook login was cancelled.
    case fbLoginWasCancelled
    /// Facebook Error
    case facebookError(String)
    /// Unhandled error type
    case unknown(Error)
    // Database
    /// Invalid product identifier
    case invalidProductIdentifier
    /// Invalid product model identifier
    case invalidProductModelID
    /// Invalid product index
    case invalidProductIndex
    /// Database: permissions denied
    case permissionsDenied
    
    var errorDescription: String? {
        switch self {
        case .networkError:          return "The Internet connection appears to be offline."
        case .emailValueIsEmpty:     return "Email is empty. Please fill it."
        case .passwordValueIsEmpty:  return "Password is empty. Please fill it."
        case .firstNameValueIsEmpty: return "First name is empty. Please fill it."
        case .lastNameValueIsEmpty:  return "Last name is empty. Please fill it."
        case .emailFormatIsWrong:    return "Email has wrong format."
        case .passwordLengthIsWrong: return "Password must have minimum 6 symbols."
        case .passwordsDoNotMatch:   return "You entered two different passwords. Please try again."
        case .notAcceptedPolicy:     return "Please read and accept the privacy policy."
        case .operationNotAllowed:   return "This account are disabled."
        case .weakPassword:          return "The password must be 6 characters long or more."
        case .wrongPassword:         return "The password is invalid or the user does not have a password."
        case .invalidEmail:          return "The email address is badly formatted."
        case .invalidSender:         return "The email template corresponding to this action contains invalid characters in its message."
        case .userNotFound:          return "There is no user record corresponding to this identifier."
        case .emailAlreadyInUse:     return "The email address is already in use by another account."
        case .invalidRecipientEmail: return "An invalid recipient email address was sent in the request."
        case .fbLoginWasCancelled:   return "The facebook login was cancelled."
        case .facebookError(let message): return message
        case .unknown(let error):    return "Unhandled error type: \(String(describing: error)) \(error.localizedDescription)"
            
        case .invalidProductIdentifier: return "Invalid product identifier"
        case .invalidProductModelID:    return "Invalid product model identifier"
        case .invalidProductIndex:      return "Invalid product index"
        case .permissionsDenied:        return "Database: permissions denied"
        }
    }
}
