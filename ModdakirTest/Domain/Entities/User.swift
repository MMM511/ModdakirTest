//
//  User.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

public struct User: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let email: String
    public let avatarURL: URL?
   
    public let token: String?
    public let isPending: Bool

    public let missingFields: [String]

    public init(
        id: String,
        name: String,
        email: String,
        avatarURL: URL? = nil,
        token: String? = nil,
        isPending: Bool = false,
        missingFields: [String] = []
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.token = token
        self.isPending = isPending
        self.missingFields = missingFields
    }
}
