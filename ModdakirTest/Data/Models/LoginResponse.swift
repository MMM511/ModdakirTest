//
//  LoginResponse.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

struct LoginResponse: Decodable {
    let id: String?
    let username: String?
    let email: String?
    let fullName: String?
    let phone: String?
    let avatarUrl: String?
    let country: String?
    let city: String?
    let isRegistrationCompleted: Bool?
}
