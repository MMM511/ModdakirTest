//
//  ApiEnvelope.swift
//  ModdakirTest
//
//  Created by Hamada Mahmoud on 16/10/2026.
//

import Foundation

struct ApiEnvelope<T: Decodable>: Decodable {
    let status: String?
    let result: String?
    let error: EnvelopeError?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case status
        case result
        case error
        case data
    }

    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        result = try container.decodeIfPresent(String.self, forKey: .result)
        error = try container.decodeIfPresent(EnvelopeError.self, forKey: .error)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}

struct EnvelopeError: Decodable {
    let code: String?
    let message: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case code
        case message
        case description
    }

    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}
