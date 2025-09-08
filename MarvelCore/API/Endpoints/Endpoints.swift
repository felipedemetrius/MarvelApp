//
//  Endpoints.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

public struct Endpoints {
    public static let baseURL = URL(string: "https://gateway.marvel.com")!

    public enum Paths: String {
        case characters = "/v1/public/characters"
        case invalidPath = "/v1/public/characterssss"
    }
}
