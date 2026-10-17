//
//  LoginRequest.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String?
    let phone: String?
    let username: String?
    let password: String

    static func credentials(identifier: String, password: String) -> LoginRequest {
        if identifier.contains("@") {
            return LoginRequest(email: identifier, phone: nil, username: nil, password: password)
        }
        return LoginRequest(email: nil, phone: nil, username: identifier, password: password)
    }
}
