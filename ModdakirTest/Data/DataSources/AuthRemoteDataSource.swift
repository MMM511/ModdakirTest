//
//  AuthRemoteDataSource.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

protocol AuthRemoteDataSource {
    func login(identifier: String, password: String) async -> Result<User, AuthError>
    func socialLogin(
        provider: SocialProvider,
        providerUserId: String,
        email: String?,
        fullName: String?,
        avatarURL: URL?
    ) async -> Result<User, AuthError>
}

final class DefaultAuthRemoteDataSource: AuthRemoteDataSource {
    private let api: AuthAPI
    private let deviceUUID: String?

    init(api: AuthAPI, deviceUUID: String? = nil) {
        self.api = api
        self.deviceUUID = deviceUUID
    }

    func login(identifier: String, password: String) async -> Result<User, AuthError> {
        let result = await api.login(.credentials(identifier: identifier, password: password))
        return result.flatMap { payload in
            guard let user = UserMapping.user(from: payload) else {
                return .failure(.server(message: "Empty response from server."))
            }
            return .success(user)
        }
    }

    func socialLogin(
        provider: SocialProvider,
        providerUserId: String,
        email: String?,
        fullName: String?,
        avatarURL: URL?
    ) async -> Result<User, AuthError> {
        let request = SocialLoginRequest(
            provider: provider,
            providerUserId: providerUserId,
            email: email,
            fullName: fullName,
            avatarUrl: avatarURL?.absoluteString,
            deviceUUID: deviceUUID
        )
        let result = await api.socialLogin(request)
        return result.map {
            UserMapping.user(
                from: $0,
                displayName: fullName,
                email: email,
                avatarURL: avatarURL
            )
        }
    }
}
