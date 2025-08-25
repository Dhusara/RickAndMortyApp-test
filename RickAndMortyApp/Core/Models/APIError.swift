//
//  APIError.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import Foundation

struct APIErrorResponse: Decodable {
    let error: String
}

enum APIError: LocalizedError {
    case invalidURL
    case http(code: Int, message: String?)
    case decoding(Error)
    case transport(Error)

    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "Invalid URL."
            case .http(let code, let message):
                return "HTTP \(code)." + (message.map { " \($0)" } ?? "")
            case .decoding(let err):
                return "Decoding failed: \(err.localizedDescription)"
            case .transport(let err):
                return "Network error: \(err.localizedDescription)"
        }
    }
}
