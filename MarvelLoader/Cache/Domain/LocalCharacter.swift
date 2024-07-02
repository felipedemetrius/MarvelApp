//
//  LocalCharacter.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

public struct LocalCharacter: Hashable, Equatable {
    public let id: Int
    public let name, description, modified: String
    public let resourceURI: String
    public let thumbnail: LocalThumbnail
    
    public init(id: Int, name: String, description: String, modified: String, resourceURI: String, thumbnail: LocalThumbnail) {
        self.id = id
        self.name = name
        self.description = description
        self.modified = modified
        self.resourceURI = resourceURI
        self.thumbnail = thumbnail
    }
}
