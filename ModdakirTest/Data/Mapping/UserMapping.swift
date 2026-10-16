//
//  UserMapping.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//


//  الكوبري اللي بيحول ال data to domain

import Foundation

enum UserMapping {
    
    static func user(from response: LoginResponse) -> User? {
        guard let consumer = response.consumer else { return nil }
        let email = consumer.email ?? ""
        let name = consumer.fullName ?? consumer.username ?? email
        return User(
            id: consumer.id ?? consumer.username ?? email,
            name: name.isEmpty ? "User" : name,
            email: email,
            avatarURL: consumer.avatarUrl.flatMap(URL.init(string:)),
            token: response.accessToken,
            isPending: !(consumer.isRegistrationCompleted ?? true)
        )
    }
    
    static func user( from response: SocialLoginResponse,displayName: String?,email: String?, avatarURL: URL?) -> User {
        let resolvedEmail = email ?? ""
        let resolvedName = displayName ?? resolvedEmail
        return User(id: response.providerUserId ?? UUID().uuidString, name: resolvedName.isEmpty ? "User" : resolvedName,email: resolvedEmail, avatarURL: avatarURL, token: response.accessToken,isPending: response.socialMediaAccountPending, missingFields: response.missingFields
        )
    }
}
