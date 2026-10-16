//
//  AuthRepositoryImpl.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let remote: AuthRemoteDataSource
    private let session: SessionStore

    init(remote: AuthRemoteDataSource, session: SessionStore) {
        self.remote = remote
        self.session = session
    }

    func login(identifier: String, password: String) async -> Result<User, AuthError> {
        let result = await remote.login(identifier: identifier, password: password)
        return persist(result)
    }

    func socialLogin(
        provider: SocialProvider,
        providerUserId: String,
        email: String?,
        fullName: String?,
        avatarURL: URL?
    ) async -> Result<User, AuthError> {
        let result = await remote.socialLogin(
            provider: provider,
            providerUserId: providerUserId,
            email: email,
            fullName: fullName,
            avatarURL: avatarURL
        )
        return persist(result)
    }

    func logout() {
        session.clear()
    }

    func currentUser() -> User? {
        session.load()
    }

    private func persist(_ result: Result<User, AuthError>) -> Result<User, AuthError> {
        if case .success(let user) = result {
            session.save(user)
        }
        return result
    }
}
