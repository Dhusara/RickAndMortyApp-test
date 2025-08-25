//
//  APIService.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import Foundation

final class APIService {
    
    static let shared: APIService = APIService()
    
    /// As we have only this url, I'd like to force unwrap it for faster coding
    private let baseURL = URL(string: "https://rickandmortyapi.com/api/")
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.session.configuration.timeoutIntervalForRequest = 20
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        self.decoder = decoder
    }

    private func get<T: Decodable>(_ path: String,  query: [URLQueryItem] = []) async throws -> T? {
        guard let baseURL,
              var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: false)
        else { return nil }
        
        if !query.isEmpty {
            components.queryItems = query
        }
        
        guard let url = components.url else { throw APIError.invalidURL }
        
        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse else {
                throw APIError.transport(URLError(.badServerResponse))
            }
            
            guard (200...299).contains(http.statusCode) else {
                let message = (try? decoder.decode(APIErrorResponse.self, from: data))?.error
                throw APIError.http(code: http.statusCode, message: message)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch let err as APIError {
            throw err
        } catch {
            throw APIError.transport(error)
        }
    }

    public func fetchCharacters(page: Int) async throws -> Response<CharacterModel>? {
        try await get(Endpoints.character.rawValue)
    }
    
    public func fetchCharacter(id: Int) async throws -> CharacterModel? {
        try await get(Endpoints.character.rawValue + "/\(id)")
    }
}
