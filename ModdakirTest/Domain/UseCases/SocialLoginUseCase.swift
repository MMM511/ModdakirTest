//
//  SocialLoginUseCase.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

struct SocialLoginUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(provider: SocialProvider, profile: ProviderProfile) async -> Result<User, AuthError> {
        await repository.socialLogin(
            provider: provider,
            providerUserId: profile.providerUserId,
            email: profile.email,
            fullName: profile.fullName,
            avatarURL: profile.avatarURL
        )
    }
}
