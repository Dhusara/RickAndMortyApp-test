//
//  InfoModel.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import Foundation

struct InfoModel: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
