//
//  UserMapping.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

enum UserMapping {
    static func user(from response: LoginResponse) -> User {
        let email = response.email ?? ""
        let name = response.fullName ?? response.username ?? email
        return User(
            id: response.id ?? response.username ?? email,
            name: name.isEmpty ? "User" : name,
            email: email,
            avatarURL: response.avatarUrl.flatMap(URL.init(string:)),
            token: nil,
            isPending: !(response.isRegistrationCompleted ?? true)
        )
    }
    
    static func user( from response: SocialLoginResponse,displayName: String?,email: String?, avatarURL: URL?) -> User {
        let resolvedEmail = email ?? ""
        let resolvedName = displayName ?? resolvedEmail
        return User(id: response.providerUserId ?? UUID().uuidString, name: resolvedName.isEmpty ? "User" : resolvedName,email: resolvedEmail, avatarURL: avatarURL, token: response.accessToken,isPending: response.socialMediaAccountPending
        )
    }
}
