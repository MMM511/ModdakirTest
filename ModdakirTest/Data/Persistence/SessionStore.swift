//
//  SessionStore.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation
import Security

protocol SessionStore {
    func save(_ user: User)
    func load() -> User?
    func clear()
}

final class KeychainSessionStore: SessionStore {
    private let service: String
    private let account = "auth.session"

    init(service: String = Bundle.main.bundleIdentifier ?? "com.ModdakirTest") {
        self.service = service
    }

    func save(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        let query = baseQuery()
        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        } else {
            var addQuery = query
            addQuery[kSecValueData as String] = data
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }

    func load() -> User? {
        var query = baseQuery()
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    func clear() {
        SecItemDelete(baseQuery() as CFDictionary)
    }


    private func baseQuery() -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }
}
