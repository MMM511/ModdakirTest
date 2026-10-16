//
//  EmailLoginUseCaseTests.swift
//  ModdakirTestTests
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

@testable import ModdakirTest
import XCTest

final class EmailLoginUseCaseTests: XCTestCase {
    private var repository: FakeAuthRepository!
    private var useCase: EmailLoginUseCase!

    override func setUp() {
        super.setUp()
        repository = FakeAuthRepository()
        useCase = EmailLoginUseCase(repository: repository)
    }

    func testEmptyIdentifierFailsValidationWithoutCallingRepository() async {
        let result = await useCase.execute(identifier: "   ", password: "secret")

        guard case .failure(.validation) = result else {
            return XCTFail("Expected validation failure, got \(result)")
        }
        XCTAssertTrue(repository.loginCalls.isEmpty)
    }

    func testEmptyPasswordFailsValidationWithoutCallingRepository() async {
        let result = await useCase.execute(identifier: "user@mail.com", password: "")

        guard case .failure(.validation) = result else {
            return XCTFail("Expected validation failure, got \(result)")
        }
        XCTAssertTrue(repository.loginCalls.isEmpty)
    }

    func testValidInputTrimsIdentifierAndForwardsToRepository() async {
        let user = User(id: "1", name: "Nora", email: "nora@mail.com")
        repository.loginResult = .success(user)

        let result = await useCase.execute(identifier: "  nora@mail.com  ", password: "secret")

        guard case .success(let returned) = result else {
            return XCTFail("Expected success, got \(result)")
        }
        XCTAssertEqual(returned, user)
        XCTAssertEqual(repository.loginCalls.count, 1)
        XCTAssertEqual(repository.loginCalls.first?.identifier, "nora@mail.com")
        XCTAssertEqual(repository.loginCalls.first?.password, "secret")
    }

    func testRepositoryFailurePropagates() async {
        repository.loginResult = .failure(.invalidCredentials)

        let result = await useCase.execute(identifier: "user@mail.com", password: "wrong")

        guard case .failure(.invalidCredentials) = result else {
            return XCTFail("Expected invalidCredentials, got \(result)")
        }
    }
}
