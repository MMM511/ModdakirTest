//
//  AuthHeaders.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

struct AuthHeaders {
    static let appName = "wl_2"
    static let userType = "User_S"
    static let isKidsApp = "false"
    static let acceptLanguage = "ar"

    static var dictionary: [String: String] {
        [
            "appName": appName,
            "Accept-Language": acceptLanguage,
            "is-kids-app": isKidsApp,
            "userType": userType,
            "Content-Type": "application/json"
        ]
    }
}
