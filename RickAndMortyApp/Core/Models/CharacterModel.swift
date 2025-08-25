//
//  CharacterModel.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//


import Foundation

struct CharacterModel: Decodable {
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let origin: CharacterOrigin
    let location: CharacterLocation
    
    struct CharacterOrigin: Decodable {
        let name: String
        let url: String
    }

    struct CharacterLocation: Decodable {
        let name: String
        let url: String
    }
}
