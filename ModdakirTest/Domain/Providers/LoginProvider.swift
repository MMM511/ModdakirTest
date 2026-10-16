//
//  LoginProvider.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation
import UIKit


protocol LoginProvider {
    var provider: SocialProvider { get }
    func signIn(presenting: UIViewController) async -> Result<ProviderProfile, AuthError>
}
