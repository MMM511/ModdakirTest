//
//  SocialLoginUseCaseTests.swift
//  ModdakirTestTests
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

@testable import ModdakirTest
import XCTest

final class SocialLoginUseCaseTests: XCTestCase {
    private var repository: FakeAuthRepository!

    override func setUp() {
        super.setUp()
        repository = FakeAuthRepository()
    }

    func testGoogleProfileForwardsProviderAndUserId() async {
        let user = User(id: "gid-1", name: "Omar", email: "omar@mail.com")
        repository.socialResult = .success(user)
        let useCase = SocialLoginUseCase(repository: repository)
        let profile = ProviderProfile(providerUserId: "gid-1", email: "omar@mail.com", fullName: "Omar", avatarURL: nil)

        let result = await useCase.execute(provider: .google, profile: profile)

        guard case .success(let returned) = result else {
            return XCTFail("Expected success, got \(result)")
        }
        XCTAssertEqual(returned, user)
        XCTAssertEqual(repository.socialCalls.count, 1)
        XCTAssertEqual(repository.socialCalls.first?.provider, .google)
        XCTAssertEqual(repository.socialCalls.first?.providerUserId, "gid-1")
    }

    func testAppleFailurePropagates() async {
        repository.socialResult = .failure(.cancelled)
        let useCase = SocialLoginUseCase(repository: repository)
        let profile = ProviderProfile(providerUserId: "apple-id", email: nil, fullName: nil, avatarURL: nil)

        let result = await useCase.execute(provider: .apple, profile: profile)

        guard case .failure(.cancelled) = result else {
            return XCTFail("Expected cancelled, got \(result)")
        }
    }

    func testLogoutClearsSession() {
        repository.storedUser = User(id: "1", name: "Nora", email: "nora@mail.com")
        let useCase = LogoutUseCase(repository: repository)

        useCase.execute()

        XCTAssertEqual(repository.logoutCalls, 1)
        XCTAssertNil(repository.currentUser())
    }
}
