//
//  LoginRequestTests.swift
//  ModdakirTestTests
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

@testable import ModdakirTest
import XCTest

final class LoginRequestTests: XCTestCase {
    func testEmailIdentifierRoutesToEmailField() {
        let request = LoginRequest.credentials(identifier: "user@mail.com", password: "secret")

        XCTAssertEqual(request.email, "user@mail.com")
        XCTAssertNil(request.username)
        XCTAssertEqual(request.password, "secret")
    }

    func testUsernameIdentifierRoutesToUsernameField() {
        let request = LoginRequest.credentials(identifier: "m.ibrahim", password: "secret")

        XCTAssertNil(request.email)
        XCTAssertEqual(request.username, "m.ibrahim")
    }

    func testSocialProviderRawValuesMatchBackend() {
        XCTAssertEqual(SocialProvider.google.rawValue, "Google")
        XCTAssertEqual(SocialProvider.apple.rawValue, "Apple")
    }
}
