//
//  GoogleLoginProvider.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation
import GoogleSignIn
import UIKit

final class GoogleLoginProvider: LoginProvider {
    let provider: SocialProvider = .google

    private let clientID: String

    init(clientID: String) {
        self.clientID = clientID
    }

    func signIn(presenting: UIViewController) async -> Result<ProviderProfile, AuthError> {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)
            let googleUser = result.user
            guard let providerUserId = googleUser.userID, !providerUserId.isEmpty else {
                return .failure(.unknown(message: "Google sign-in returned no user ID."))
            }
            return .success(ProviderProfile(
                providerUserId: providerUserId,
                email: googleUser.profile?.email,
                fullName: googleUser.profile?.name,
                avatarURL: googleUser.profile?.imageURL(withDimension: 200)
            ))
        } catch {
            return .failure(map(error))
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }


    private func map(_ error: Error) -> AuthError {
        let nsError = error as NSError
        if (nsError.domain as NSString).contains("GIDSignIn"), nsError.code == -5 {
            return .cancelled
        }
        return .unknown(message: error.localizedDescription)
    }
}
