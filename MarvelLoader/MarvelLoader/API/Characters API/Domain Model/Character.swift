//
//  Character.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

public struct Character: Hashable, Equatable {
    public var id: Int
    public var name, description, modified: String
    public var resourceURI: String
    public var thumbnail: Thumbnail

    public var urlImage: String {
        return thumbnail.path + "." + thumbnail.thumbnailExtension
    }

    public init(id: Int, name: String, description: String, modified: String, resourceURI: String, thumbnail: Thumbnail) {
        self.id = id
        self.name = name
        self.description = description
        self.modified = modified
        self.resourceURI = resourceURI
        self.thumbnail = thumbnail
    }
}

public struct Thumbnail: Hashable, Equatable {
    public var path, thumbnailExtension: String
    public init(path: String, thumbnailExtension: String) {
        self.path = path
        self.thumbnailExtension = thumbnailExtension
    }
}
