//
//  CoreDataCharacterStore+CharacterStore.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import CoreData

extension CoreDataCharacterStore: CharacterStore {
    
    public func retrieve() throws -> CachedFeed? {
        try ManagedCache.find(in: context).map {
            CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
        }
    }
    
    public func insert(_ feed: [LocalCharacter], timestamp: Date) throws {
        let managedCache = try ManagedCache.newUniqueInstance(in: context)
        managedCache.timestamp = timestamp
        managedCache.feed = ManagedCharacter.characters(from: feed, in: context)
        try context.save()
    }
    
    public func deleteCachedFeed() throws {
        try ManagedCache.deleteCache(in: context)
    }
    
}
