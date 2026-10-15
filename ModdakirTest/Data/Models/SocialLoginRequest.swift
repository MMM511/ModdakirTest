//
//  SocialLoginRequest.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

struct SocialLoginRequest: Encodable {
    let email: String?
    let providerUserId: String
    let providerType: String
    let phone: String?
    let fullName: String?
    let gender: String?
    let country: String?
    let city: String?
    let address: String?
    let avatarUrl: String?
    let deviceUUID: String?
    let idfa: String?

    init(
        provider: SocialProvider,
        providerUserId: String,
        email: String? = nil,
        fullName: String? = nil,
        avatarUrl: String? = nil,
        deviceUUID: String? = nil
    ) {
        self.email = email
        self.providerUserId = providerUserId
        self.providerType = provider.rawValue
        self.phone = nil
        self.fullName = fullName
        self.gender = nil
        self.country = nil
        self.city = nil
        self.address = nil
        self.avatarUrl = avatarUrl
        self.deviceUUID = deviceUUID
        self.idfa = nil
    }
}
