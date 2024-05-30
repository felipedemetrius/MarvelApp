//
//  Character.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

public struct Character: Hashable, Equatable {
    public let id: Int
    public let name, description, modified: String
    public let resourceURI: String
    public let thumbnail: Thumbnail

    public var urlImage: String {
        return thumbnail.path + "." + thumbnail.thumbnailExtension
    }

    public init(id: Int, name: String, description: String, modified: String, resourceURI: String, thumbnailPath: String, thumbnailExtension: String) {
        self.id = id
        self.name = name
        self.description = description
        self.modified = modified
        self.resourceURI = resourceURI
        self.thumbnail = Thumbnail(path: thumbnailPath, thumbnailExtension: thumbnailExtension)
    }
}
