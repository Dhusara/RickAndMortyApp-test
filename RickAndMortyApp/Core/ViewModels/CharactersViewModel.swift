//
//  CharactersViewModel.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import UIKit

enum CharacterEvent {
    case didLoadData
    case didShowError(_ : String)
    case isLoading(_ : Bool)
}

final class CharactersViewModel {
    
    public var eventHandler: ((CharacterEvent) -> ())?
    
    private(set) var dataSource: [CharacterModel] = []
    private(set) var page = 1
    private(set) var hasMore = true
    private(set) var isLoading = false
    
    public func didLoad() {
        Task {
            await loadInitial()
        }
    }
    
    public func numberOfItems() -> Int {
        dataSource.count
    }
    
    public func item(at index: Int) -> CharacterModel? {
        guard dataSource.indices.contains(index) else { return nil }
        return dataSource[index]
    }
    
    public func willDisplayCell(at index: Int) {
        guard hasMore, !isLoading, index >= dataSource.count - 5 else { return }
        
        page += 1
        Task {
            await load(page: page, reset: false)
        }
    }
    
    // MARK: Loading
    
    private func loadInitial() async {
        page = 1
        hasMore = true
        await load(page: page, reset: true)
    }

    private func load(page: Int, reset: Bool) async {
        isLoading = true
        
        await MainActor.run {
            eventHandler?(.isLoading(true))
        }

        do {
            let response: Response<CharacterModel>? = try await APIService.shared.fetchCharacters(page: page)
            
            hasMore = (response?.info.next != nil)
            
            if reset {
                dataSource = response?.results ?? []
            } else {
                dataSource.append(contentsOf: response?.results ?? [])
            }
            
            await MainActor.run {
                eventHandler?(.didLoadData)
            }
        } catch {
            await MainActor.run {
                eventHandler?(.didShowError("Failed to load.\n\(error.localizedDescription)"))
            }
        }

        isLoading = false
        await MainActor.run {
            eventHandler?(.isLoading(false))
        }
    }
}
