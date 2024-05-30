//
//  RootResponse.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

struct Root: Decodable {
    let data: Result

    struct Result: Decodable {
        let results: [CharacterResponse]
    }
}
