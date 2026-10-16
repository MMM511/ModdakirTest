//
//  FakeAuthRepository.swift
//  ModdakirTestTests
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

@testable import ModdakirTest
import Foundation

final class FakeAuthRepository: AuthRepository {
    var loginResult: Result<User, AuthError> = .failure(.unknown(message: "unstubbed"))
    var socialResult: Result<User, AuthError> = .failure(.unknown(message: "unstubbed"))
    var storedUser: User?

    private(set) var loginCalls: [(identifier: String, password: String)] = []
    private(set) var socialCalls: [(provider: SocialProvider, providerUserId: String)] = []
    private(set) var logoutCalls = 0

    func login(identifier: String, password: String) async -> Result<User, AuthError> {
        loginCalls.append((identifier, password))
        return loginResult
    }

    func socialLogin(
        provider: SocialProvider,
        providerUserId: String,
        email: String?,
        fullName: String?,
        avatarURL: URL?
    ) async -> Result<User, AuthError> {
        socialCalls.append((provider, providerUserId))
        return socialResult
    }

    func logout() {
        logoutCalls += 1
        storedUser = nil
    }

    func currentUser() -> User? {
        storedUser
    }
}
