//
//  CharactersMapper.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

public final class CharactersMapper {
        
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Character] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            guard let error = try? NetworkErrorMapper.map(data, from: response) else {
                throw NetworkErrorCases.invalidData
            }
            throw NetworkErrorCases.error(error)
        }
        
        return root.data.results.map({ Character(response: $0)})
    }
}
