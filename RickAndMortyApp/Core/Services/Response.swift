//
//  Response.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let info: InfoModel
    let results: [T]
}
