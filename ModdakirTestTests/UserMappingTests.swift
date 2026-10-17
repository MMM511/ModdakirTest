//
//  UserMappingTests.swift
//  ModdakirTestTests
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

@testable import ModdakirTest
import XCTest

final class UserMappingTests: XCTestCase {
    func testLoginResponseMapsAllFields() {
        let response = LoginResponse(
            accessToken: "token-123",
            consumer: ConsumerDTO(
                id: "u-1",
                username: "m.ibrahim",
                email: "m.ibrahim@moddakir.com",
                fullName: "Mohammed",
                phone: "+20100",
                avatarUrl: "https://example.com/a.png",
                country: "EG",
                city: "Cairo",
                isRegistrationCompleted: true
            )
        )

        let user = UserMapping.user(from: response)

        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, "u-1")
        XCTAssertEqual(user?.name, "Mohammed")
        XCTAssertEqual(user?.token, "token-123")
        XCTAssertEqual(user?.isPending, false)
        XCTAssertEqual(user?.avatarURL?.absoluteString, "https://example.com/a.png")
    }

    func testLoginResponseMissingConsumerReturnsNil() {
        let response = LoginResponse(accessToken: "token-123", consumer: nil)

        XCTAssertNil(UserMapping.user(from: response))
    }

    func testUnfinishedRegistrationMapsToPending() {
        let response = LoginResponse(
            accessToken: nil,
            consumer: ConsumerDTO(
                id: "u-2",
                username: nil,
                email: "new@mail.com",
                fullName: nil,
                phone: nil,
                avatarUrl: "",
                country: nil,
                city: nil,
                isRegistrationCompleted: false
            )
        )

        let user = UserMapping.user(from: response)

        XCTAssertEqual(user?.isPending, true)
        // Falls back to email when no display name, empty string URL stays nil.
        XCTAssertEqual(user?.name, "new@mail.com")
        XCTAssertNil(user?.avatarURL)
    }

    func testSocialResponseKeepsTokenPendingAndMissingFields() {
        let response = SocialLoginResponse(
            providerUserId: "gid-9",
            providerType: "Google",
            accessToken: "social-token",
            missingFields: ["phone", "gender"],
            socialMediaAccountPending: true
        )

        let user = UserMapping.user(
            from: response,
            displayName: "Omar",
            email: "omar@mail.com",
            avatarURL: nil
        )

        XCTAssertEqual(user.id, "gid-9")
        XCTAssertEqual(user.token, "social-token")
        XCTAssertEqual(user.isPending, true)
        XCTAssertEqual(user.missingFields, ["phone", "gender"])
    }
}
