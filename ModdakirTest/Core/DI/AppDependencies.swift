//
//  AppDependencies.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

import Foundation
import UIKit

final class AppDependencies {

    static let shared = AppDependencies()

    private let api: AuthAPI
    private let session: SessionStore
    private let repository: AuthRepository

    init(
        api: AuthAPI = AlamofireAuthAPI(),
        session: SessionStore = KeychainSessionStore()
    ) {
        self.api = api
        self.session = session
        self.repository = AuthRepositoryImpl(
            remote: DefaultAuthRemoteDataSource(
                api: api,
                deviceUUID: UIDevice.current.identifierForVendor?.uuidString
            ),
            session: session
        )
    }


    func makeEmailLoginUseCase() -> EmailLoginUseCase {
        EmailLoginUseCase(repository: repository)
    }

    func makeSocialLoginUseCase() -> SocialLoginUseCase {
        SocialLoginUseCase(repository: repository)
    }

    func makeLogoutUseCase() -> LogoutUseCase {
        LogoutUseCase(repository: repository)
    }

    func makeGoogleProvider() -> GoogleLoginProvider? {
        guard let clientID = googleClientID() else { return nil }
        return GoogleLoginProvider(clientID: clientID)
    }

    func makeAppleProvider() -> AppleLoginProvider {
        AppleLoginProvider()
    }

    func currentUser() -> User? {
        repository.currentUser()
    }

    private func googleClientID() -> String? {
        guard let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            return nil
        }
        return plist["CLIENT_ID"] as? String
    }
}
