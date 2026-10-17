//
//  ProviderProfile.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation


struct ProviderProfile: Equatable, Sendable {
    let providerUserId: String
    let email: String?
    let fullName: String?
    let avatarURL: URL?
}
