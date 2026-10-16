//
//  AppleLoginProvider.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import AuthenticationServices
import Foundation
import UIKit

final class AppleLoginProvider: NSObject, LoginProvider {
    let provider: SocialProvider = .apple

    private var continuation: CheckedContinuation<Result<ProviderProfile, AuthError>, Never>?

    func signIn(presenting: UIViewController) async -> Result<ProviderProfile, AuthError> {
        await withCheckedContinuation { continuation in
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            self.presentingViewController = presenting
            self.continuation = continuation
            controller.performRequests()
        }
    }


    private weak var presentingViewController: UIViewController?

    private func finish(with result: Result<ProviderProfile, AuthError>) {
        continuation?.resume(returning: result)
        continuation = nil
    }
}


extension AppleLoginProvider: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            finish(with: .failure(.unknown(message: "Unexpected Apple credential.")))
            return
        }
        let nameParts = [credential.fullName?.givenName, credential.fullName?.familyName].compactMap { $0 }
        let fullName = nameParts.joined(separator: " ")
        finish(with: .success(ProviderProfile(
            providerUserId: credential.user,
            email: credential.email,
            fullName: fullName.isEmpty ? nil : fullName,
            avatarURL: nil
        )))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if (error as NSError).code == 1001 {
            finish(with: .failure(.cancelled))
        } else {
            finish(with: .failure(.unknown(message: error.localizedDescription)))
        }
    }
}


extension AppleLoginProvider: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let window = presentingViewController?.view.window {
            return window
        }
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
