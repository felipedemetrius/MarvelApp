//
//  Thumbnail.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

public struct Thumbnail: Hashable, Equatable {
    public let path, thumbnailExtension: String
    public init(path: String, thumbnailExtension: String) {
        self.path = path
        self.thumbnailExtension = thumbnailExtension
    }
    
    init(response: ThumbnailResponse?) {
        self.path = response?.path.orEmpty ?? ""
        self.thumbnailExtension = response?.extension.orEmpty ?? ""
    }
}
