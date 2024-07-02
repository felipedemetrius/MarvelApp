//
//  CharacterCacheTestHelpers.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import Foundation
import MarvelLoader

func uniqueImage() -> Character {
    return Character(id: 111, name: "any", description: "any", modified: "", resourceURI: "", thumbnailPath: "https://any-url.com/image", thumbnailExtension: "jpg")
}

func uniqueImageFeed() -> (models: [Character], local: [LocalCharacter]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalCharacter(id: $0.id, name: $0.name, description: $0.description, modified: $0.modified, resourceURI: $0.resourceURI, thumbnail: LocalThumbnail(path: $0.thumbnail.path, thumbnailExtension: $0.thumbnail.thumbnailExtension)) }
    return (models, local)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
