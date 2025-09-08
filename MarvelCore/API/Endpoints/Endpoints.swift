//
//  Endpoints.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

struct Endpoints {
    static let baseURL = URL(string: "https://gateway.marvel.com")!

    enum Paths: String {
        case characters = "/v1/public/characters"
        case invalidPath = "/v1/public/characterssss"
    }
}
