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
    
    
    
    private func perform<T: Decodable, P: Encodable>(
        _ endpoint: AuthEndpoint,
        parameters: P
    ) async -> Result<T, AuthError> {
        let response = await session.request(
            endpoint.url,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: HTTPHeaders(AuthHeaders.dictionary)
        )
        .validate()
        .serializingDecodable(ApiEnvelope<T>.self)
        .response

        switch response.result {
        case .success(let envelope):
            if let data = envelope.data {
                return .success(data)
            }
            if let message = envelope.error?.message, !message.isEmpty {
                return .failure(.server(message: message))
            }
            if let raw = response.data,
               let value = try? JSONDecoder().decode(T.self, from: raw) {
                return .success(value)
            }
            return .failure(.server(message: "Empty response from server."))
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
        if let message = json["message"] as? String, !message.isEmpty { return message }
        if let message = json["detail"] as? String, !message.isEmpty { return message }
        if let message = json["errorMessage"] as? String, !message.isEmpty { return message }
        if let message = json["error"] as? String, !message.isEmpty { return message }
        if let nested = json["error"] as? [String: Any] {
            if let message = nested["message"] as? String, !message.isEmpty { return message }
            if let message = nested["description"] as? String, !message.isEmpty { return message }
        }
        return nil
    }
}
