//
//  AuthAPI.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Foundation

protocol AuthAPI {
    
    func login(_ request: LoginRequest) async -> Result<LoginResponse, AuthError>
    func socialLogin(_ request: SocialLoginRequest) async -> Result<SocialLoginResponse, AuthError>
}
