//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import Foundation

final class CharacterDetailViewModel {
    
    public var eventHandler: ((CharacterEvent) -> ())?
    
    private let id: Int
    private(set) var character: CharacterModel?
    
    init(id: Int) {
        self.id = id
    }
    
    public func viewDidLoad() {
        Task { await load() }
    }
    
    private func load() async {
        await MainActor.run {
            eventHandler?(.isLoading(true))
        }
        
        do {
            let dto = try await APIService.shared.fetchCharacter(id: id)
            self.character = dto
            await MainActor.run {
                eventHandler?(.didLoadData)
            }
        } catch {
            await MainActor.run {
                eventHandler?(.didShowError("Failed to load character.\n\(error.localizedDescription)"))
            }
        }
        
        await MainActor.run {
            eventHandler?(.isLoading(false))
        }
    }
}
