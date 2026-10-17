//
//  AuthRepositoryImplTests.swift
//  ModdakirTestTests
//
//  Created by Hamada Mahmoud on 17/10/2026.
//

@testable import ModdakirTest
import XCTest

final class AuthRepositoryImplTests: XCTestCase {
    private var remote: StubAuthRemoteDataSource!
    private var session: FakeSessionStore!
    private var repository: AuthRepositoryImpl!

    override func setUp() {
        super.setUp()
        remote = StubAuthRemoteDataSource()
        session = FakeSessionStore()
        repository = AuthRepositoryImpl(remote: remote, session: session)
    }

    func testCompletedUserIsPersisted() async {
        remote.loginResult = .success(User(id: "1", name: "Nora", email: "nora@mail.com", isPending: false))

        await repository.login(identifier: "user@mail.com", password: "secret")

        XCTAssertEqual(session.savedUser?.id, "1")
    }

    func testPendingUserIsNotPersisted() async {
        remote.loginResult = .success(User(id: "2", name: "Pending", email: "p@mail.com", isPending: true))

        let result = await repository.login(identifier: "p@mail.com", password: "secret")

        guard case .success = result else {
            return XCTFail("Expected success, got \(result)")
        }
        XCTAssertNil(session.savedUser)
        XCTAssertNil(session.load())
    }

    func testSocialPendingUserIsNotPersisted() async {
        remote.socialResult = .success(User(id: "gid-9", name: "Omar", email: "omar@mail.com", isPending: true))

        await repository.socialLogin(
            provider: .google,
            providerUserId: "gid-9",
            email: "omar@mail.com",
            fullName: "Omar",
            avatarURL: nil
        )

        XCTAssertNil(session.savedUser)
    }

    func testSocialCompletedUserIsPersisted() async {
        remote.socialResult = .success(User(id: "gid-1", name: "Omar", email: "omar@mail.com", isPending: false))

        await repository.socialLogin(
            provider: .google,
            providerUserId: "gid-1",
            email: "omar@mail.com",
            fullName: "Omar",
            avatarURL: nil
        )

        XCTAssertEqual(session.savedUser?.id, "gid-1")
    }
}

private final class FakeSessionStore: SessionStore {
    private(set) var savedUser: User?

    func save(_ user: User) {
        savedUser = user
    }

    func load() -> User? {
        savedUser
    }

    func clear() {
        savedUser = nil
    }
}

private final class StubAuthRemoteDataSource: AuthRemoteDataSource {
    var loginResult: Result<User, AuthError> = .failure(.unknown(message: "unstubbed"))
    var socialResult: Result<User, AuthError> = .failure(.unknown(message: "unstubbed"))

    func login(identifier: String, password: String) async -> Result<User, AuthError> {
        loginResult
    }

    func socialLogin(
        provider: SocialProvider,
        providerUserId: String,
        email: String?,
        fullName: String?,
        avatarURL: URL?
    ) async -> Result<User, AuthError> {
        socialResult
    }
}
