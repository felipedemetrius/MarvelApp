//
//  LocalThumbnail.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

public struct LocalThumbnail: Hashable, Equatable {
    public let path, thumbnailExtension: String
    public init(path: String, thumbnailExtension: String) {
        self.path = path
        self.thumbnailExtension = thumbnailExtension
    }
}
