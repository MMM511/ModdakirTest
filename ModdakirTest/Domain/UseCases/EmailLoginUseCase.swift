//
//  EmailLoginUseCase.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation


struct EmailLoginUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(identifier: String, password: String) async -> Result<User, AuthError> {
        let trimmed = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return .failure(.validation(message: "Please enter your email or username."))
        }
        guard !password.isEmpty else {
            return .failure(.validation(message: "Please enter your password."))
        }
        return await repository.login(identifier: trimmed, password: password)
    }
}
