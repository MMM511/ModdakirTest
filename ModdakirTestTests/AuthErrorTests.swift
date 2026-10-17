//
//  AuthErrorTests.swift
//  ModdakirTestTests
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

@testable import ModdakirTest
import XCTest

final class AuthErrorTests: XCTestCase {
    func testPendingWithFieldsListsThem() {
        let error = AuthError.pendingCompletion(missingFields: ["phone", "gender"])

        XCTAssertEqual(error.userMessage, "Your account is pending completion: phone, gender.")
    }

    func testPendingWithoutFieldsFallsBackToGenericMessage() {
        let error = AuthError.pendingCompletion(missingFields: [])

        XCTAssertEqual(error.userMessage, "Your account needs a few more details to be completed.")
    }

    func testFixedMessages() {
        XCTAssertEqual(
            AuthError.invalidCredentials.userMessage,
            "Incorrect email or password. Please try again."
        )
        XCTAssertEqual(AuthError.cancelled.userMessage, "Sign-in was cancelled.")
        XCTAssertEqual(
            AuthError.sessionExpired.userMessage,
            "Your session has expired. Please sign in again."
        )
    }

    func testServerAndUnknownCarryBackendMessage() {
        XCTAssertEqual(AuthError.server(message: "رقم الهاتف غير صحيح").userMessage, "رقم الهاتف غير صحيح")
        XCTAssertEqual(AuthError.unknown(message: "boom").userMessage, "boom")
    }
}
