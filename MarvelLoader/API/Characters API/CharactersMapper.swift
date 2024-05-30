//
//  CharactersMapper.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

public final class CharactersMapper {
    private struct Root: Decodable {
        private let data: Result

        private struct Result: Decodable {
            let results: [RemoteCharacter]
        }
        
        private struct RemoteCharacter: Decodable {
            let id: Int?
            let name, description, modified: String?
            let resourceURI: String?
            let thumbnail: RemoteThumbnail?
        }
        
        private struct RemoteThumbnail: Decodable {
            let path, `extension`: String?
        }

        var chars: [Character] {
            data.results.map { Character(id: $0.id.orZero,
                                         name: $0.name.orEmpty,
                                         description: $0.description.orEmpty,
                                         modified: $0.modified.orEmpty,
                                         resourceURI: $0.resourceURI.orEmpty,
                                         thumbnail: Thumbnail(path: $0.thumbnail?.path.orEmpty ?? "",
                                                              thumbnailExtension: $0.thumbnail?.extension.orEmpty ?? ""))}
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Character] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.chars
    }
}
