//
//  CharactersMapper.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation
import FeatureFeed

public final class CharactersMapper {
        
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Character] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            guard let error = try? NetworkErrorMapper.map(data, from: response) else {
                throw NetworkErrorCases.invalidData
            }
            throw NetworkErrorCases.apiError(error)
        }
        
        return root.data.results.map({
            Character(
                id: $0.id.orZero,
                name: $0.name.orEmpty,
                description: $0.description.orEmpty,
                modified: $0.modified.orEmpty,
                resourceURI: $0.resourceURI.orEmpty,
                thumbnailPath: $0.thumbnail?.path ?? "",
                thumbnailExtension: $0.thumbnail?.extension ?? "")
        })
    }
}
