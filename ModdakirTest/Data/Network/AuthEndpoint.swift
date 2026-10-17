//
//  AuthEndpoint.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

enum AuthEndpoint {
    static let baseURL = "https://revamp-auth-stage.moddakir.com"

    case login
    case socialLogin

    var path: String {
        switch self {
        case .login:
            return "/api/auth/public/login"
        case .socialLogin:
            return "/api/auth/public/social-login"
        }
    }

    var url: URL {
        guard let url = URL(string: Self.baseURL + path) else {
            preconditionFailure("Invalid auth endpoint URL for path: \(path)")
        }
        return url
    }
}
