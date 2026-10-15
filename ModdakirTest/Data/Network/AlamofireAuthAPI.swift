//
//  AlamofireAuthAPI.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 15/10/2026.
//

import Alamofire
import Foundation

final class AlamofireAuthAPI: AuthAPI {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func login(_ request: LoginRequest) async -> Result<LoginResponse, AuthError> {
        await perform(.login, parameters: request)
    }
    
    func socialLogin(_ request: SocialLoginRequest) async -> Result<SocialLoginResponse, AuthError> {
        await perform(.socialLogin, parameters: request)
    }
    
    
    
    private func perform<T: Decodable, P: Encodable>(_ endpoint: AuthEndpoint,parameters: P) async -> Result<T,AuthError> {
        let response = await session.request(
            endpoint.url,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: HTTPHeaders(AuthHeaders.dictionary)
        )
            .validate()
            .serializingDecodable(T.self)
            .response
        
        switch response.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(map(error, data: response.data, statusCode: response.response?.statusCode))
        }
    }
    
    private func map(_ error: AFError, data: Data?, statusCode: Int?) -> AuthError {
        if error.isSessionTaskError {
            return .network(message: error.localizedDescription)
        }
        if statusCode == 401 {
            return .invalidCredentials
        }
        if let data, let message = backendMessage(from: data), !message.isEmpty {
            return .server(message: message)
        }
        return .unknown(message: error.localizedDescription)
    }
    
    private func backendMessage(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return (json["message"] as? String) ?? (json["error"] as? String)
    }
}
