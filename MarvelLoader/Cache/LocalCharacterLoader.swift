//
//  LocalCharacterLoader.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import Foundation

public final class LocalCharacterLoader {
    private let store: CharacterStore
    private let currentDate: () -> Date
    
    public init(store: CharacterStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalCharacterLoader: CharacterCache {
    public func save(_ feed: [Character]) throws {
        try store.deleteCachedFeed()
        try store.insert(feed.toLocal(), timestamp: currentDate())
    }
}

extension LocalCharacterLoader {
    public func load() throws -> [Character] {
        if let cache = try store.retrieve(), CharacterCachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.feed.toModels()
        }
        return []
    }
}

extension LocalCharacterLoader {
    private struct InvalidCache: Error {}
    
    public func validateCache() throws {
        do {
            if let cache = try store.retrieve(), !CharacterCachePolicy.validate(cache.timestamp, against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try store.deleteCachedFeed()
        }
    }
}

private extension Array where Element == Character {
    func toLocal() -> [LocalCharacter] {
        return map { LocalCharacter(id: $0.id, name: $0.name, description: $0.description, modified: $0.modified, resourceURI: $0.resourceURI, thumbnail: LocalThumbnail(path: $0.thumbnail.path, thumbnailExtension: $0.thumbnail.thumbnailExtension)) }
    }
}

private extension Array where Element == LocalCharacter {
    func toModels() -> [Character] {
        return map { Character(id: $0.id, name: $0.name, description: $0.description, modified: $0.modified, resourceURI: $0.resourceURI, thumbnailPath: $0.thumbnail.path, thumbnailExtension: $0.thumbnail.thumbnailExtension) }
    }
}
