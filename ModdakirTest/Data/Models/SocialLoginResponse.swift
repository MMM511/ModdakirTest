//
//  SocialLoginResponse.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

struct SocialLoginResponse: Decodable {
    let providerUserId: String?
    let providerType: String?
    let accessToken: String?
    let missingFields: [String]
    let socialMediaAccountPending: Bool

    enum CodingKeys: String, CodingKey {
        case providerUserId
        case providerType
        case accessToken
        case missingFields
        case socialMediaAccountPending
    }

    init(
        providerUserId: String? = nil,
        providerType: String? = nil,
        accessToken: String? = nil,
        missingFields: [String] = [],
        socialMediaAccountPending: Bool = false
    ) {
        self.providerUserId = providerUserId
        self.providerType = providerType
        self.accessToken = accessToken
        self.missingFields = missingFields
        self.socialMediaAccountPending = socialMediaAccountPending
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        providerUserId = try container.decodeIfPresent(String.self, forKey: .providerUserId)
        providerType = try container.decodeIfPresent(String.self, forKey: .providerType)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        missingFields = (try container.decodeIfPresent([String].self, forKey: .missingFields)) ?? []
        socialMediaAccountPending = (try container.decodeIfPresent(Bool.self, forKey: .socialMediaAccountPending)) ?? false
    }
}
