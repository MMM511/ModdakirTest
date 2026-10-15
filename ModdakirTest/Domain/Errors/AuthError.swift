//
//  AuthError.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

public enum AuthError: Error, Equatable, Sendable {
    case network(message: String)
    case server(message: String)
    case invalidCredentials
    case cancelled
    case pendingCompletion(missingFields: [String])
    case sessionExpired
    case unknown(message: String)
}

public extension AuthError {
    
    var userMessage: String {
        switch self {
        case .network:
            return "No internet connection. Please check your network and try again."
        case .server(let message):
            return message
        case .invalidCredentials:
            return "Incorrect email or password. Please try again."
        case .cancelled:
            return "Sign-in was cancelled."
        case .pendingCompletion(let missingFields):
            if missingFields.isEmpty {
                return "Your account needs a few more details to be completed."
            }
            return "Your account is pending completion: \(missingFields.joined(separator: ", "))."
        case .sessionExpired:
            return "Your session has expired. Please sign in again."
        case .unknown(let message):
            return message
        }
    }
}

extension AuthError: LocalizedError {
    public var errorDescription: String? { userMessage }
}
