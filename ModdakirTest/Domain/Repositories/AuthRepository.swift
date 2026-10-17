//
//  AuthRepository.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

protocol AuthRepository {
    
    func login(identifier: String, password: String) async -> Result<User, AuthError>
   
    func socialLogin( provider: SocialProvider, providerUserId: String, email: String?,fullName: String?,avatarURL: URL?)
    
    async -> Result<User, AuthError>
    
    func logout()
    func currentUser() -> User?
}
